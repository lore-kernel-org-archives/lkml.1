Return-Path: <linux-kernel-owner+w=401wt.eu-S1755450AbXLWAMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbXLWAMH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 19:12:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbXLWALz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 19:11:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53638 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855AbXLWALy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 19:11:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: ACPI or radeon: spontaneous reboot regression
Date: Sun, 23 Dec 2007 01:30:58 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, benh@kernel.crashing.org
References: <1198367937.8260.6.camel@cinder.waste.org>
In-Reply-To: <1198367937.8260.6.camel@cinder.waste.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712230130.58590.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 23 of December 2007, Matt Mackall wrote:
> With 2.6.24-rc2, plugging and unplugging power results in a sudden
> reboot. After the reboot, the machine boots normally until it switches
> to graphics mode, at which point the screen is scrambled. It may hang or
> repeatedly reboot at this point. Easily repeatable after just a few plug
> cycles.
> 
> Switching back to 2.6.23-rc3-mm1, I can do a dozen plug cycles with no
> problem.
> 
> Machine is a Thinkpad R51, with R250:
> 
> 01:00.0 VGA compatible controller: ATI Technologies Inc Radeon R250
> [Mobility FireGL 9000] (rev 02)

Added to the list of reported regressions as:
http://bugzilla.kernel.org/show_bug.cgi?id=9624

Thanks,
Rafael
