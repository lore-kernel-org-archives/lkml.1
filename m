Return-Path: <linux-kernel-owner+w=401wt.eu-S1754396Ab0A3T4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab0A3T4L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 14:56:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754218Ab0A3T4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 14:56:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47222 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754157Ab0A3T4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 14:56:07 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sebastian <beyonder7@tlen.pl>
Subject: Re: Uppgrade from OpenSuse 11.1 to 11.2 causes Acer laptop to overheating...
Date: Sat, 30 Jan 2010 20:56:44 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>
References: <4B6488A6.7000705@tlen.pl>
In-Reply-To: <4B6488A6.7000705@tlen.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201001302056.44162.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 30 January 2010, Sebastian wrote:
> Hello,
> I desperately seeks help or any advice from kernel experts.
> I have Acer Aspire 5315 laptop and when I updated my OpenSuse 11.1 to 
> 11.2 the laptop started to shut down to prevent overheat.
> I noticed that no fan is running and trying and playing with sensors, 
> sometimes I get information from one sensor that always says 40C, and 
> sometimes also
> from coretemp sensor that shows rapidly increasing temperature from 50C 
> to 85-89C.
> 
> I have this problem with base and pae kernel that was attached to 
> opensuse installation dvd, and later upgraded it for 2.6.33-r5 from 
> OpenSuse Factory repo - results the same.
> Does any expert have some suggestions?
> 
> On several message boards there are advice that flashin BIOS should 
> solve the problem, but IMO it can be the only solution - Linux shouldn't 
> work that way.
> On the same machine i have XP and everything is OK, stable temperature 
> is maintained, I also recently clean the vents from dust and other stuff.

First off, this seems to be ACPI-related, so added some CCs in that direction.

Second, since you decided to report the bug directly to the kernel developers,
would you be able to test non-distro kernels on your machine?

Rafael
