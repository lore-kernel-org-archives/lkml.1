Return-Path: <linux-kernel-owner+w=401wt.eu-S1754629Ab0AaCA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab0AaCA6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 21:00:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754475Ab0AaCA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 21:00:57 -0500
Received: from smtp-out2.blueyonder.co.uk ([195.188.213.5]:57631 "EHLO
	smtp-out2.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753153Ab0AaCA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 21:00:56 -0500
Message-ID: <4B64E456.3080904@blueyonder.co.uk>
Date: Sun, 31 Jan 2010 02:00:54 +0000
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.14 Thunderbird/3.0 ThunderBrowse/3.2.7
MIME-Version: 1.0
To: LKML Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: Uppgrade from OpenSuse 11.1 to 11.2 causes Acer laptop to overheating...
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sebastian wrote:
> Hello,
> I desperately seeks help or any advice from kernel experts.
> I have Acer Aspire 5315 laptop and when I updated my OpenSuse 11.1 to
> 11.2 the laptop started to shut down to prevent overheat.
> I noticed that no fan is running and trying and playing with sensors,
> sometimes I get information from one sensor that always says 40C, and
> sometimes also
> from coretemp sensor that shows rapidly increasing temperature from >
> 50C to 85-89C.
=======================================================================
As I don't have Sebastian's email address, I'm posting here.
I had a very similar problem after an openSUSE upgrade on an Acer
1501LCe laptop. At first I could not boot from the DVD, but a CD would
and compiling kernels had to be done in "powersave -l". It progressively
got worse and I was about to throw it out.
I decided to open it up a second time and have another look.
The outlet next to the CPU was blocked by an accumulation of dust which
I mistook for a foam filter the first time around.
It also seemed to be after a kernel upgrade - debated as such on the
openSUSE factory list.
I'm glad I did as it's fully back to health.
Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

