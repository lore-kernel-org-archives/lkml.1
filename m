Return-Path: <linux-kernel-owner+w=401wt.eu-S1758244AbZDODB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244AbZDODB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 23:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbZDODBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 23:01:19 -0400
Received: from smtp-out3.blueyonder.co.uk ([195.188.213.6]:59793 "EHLO
	smtp-out3.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752300AbZDODBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 23:01:18 -0400
X-Greylist: delayed 3867 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Apr 2009 23:01:18 EDT
Message-ID: <49E53EE2.2030903@blueyonder.co.uk>
Date: Wed, 15 Apr 2009 02:56:50 +0100
From: Sid Boyce <g3vbv@blueyonder.co.uk>
Reply-To: g3vbv@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: mcp55 forcedeth woes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yan Seiner wrote:
> There is a newer bios, 1702, that may address these issues - at least teh
> writeup for the 17xx bios for the m2n32 talks about a network lockup fix.
> I haven't tried yet. These are the most stable boards I've found; one of
> mine runs 6 SATA drives locally, 9 via eSATA, 2 dual DVI video cards, and
> 2 15K scsi drives, all without a hitch. It never glitches - except for
> the d*mn network, this board is a piece of perfection.
For the M2N-SLI-Deluxe I found only 1701 which causes oops when booting
any kernel on 64X2 6000 and for the M2N32-SLI 2205 which I haven't tried
so far.

Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

