using NUnit.Framework;
using UnityEngine;

namespace DroneSim.Tests.EditMode
{
    public class TimestepTests
    {
        [Test]
        public void FixedTimestep_Is500Hz()
        {
            // D-004: 500 Hz fixed physics step.
            Assert.AreEqual(0.002f, Time.fixedDeltaTime, 1e-6f);
        }
    }
}
