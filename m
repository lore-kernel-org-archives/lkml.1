Return-Path: <linux-kernel-owner+w=401wt.eu-S1755167AbYAEAOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbYAEAOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 19:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674AbYAEAOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 19:14:10 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:62098 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594AbYAEAOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 19:14:09 -0500
Date: Fri, 04 Jan 2008 19:13:53 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Querying the bios from booted linux kernel?
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200801041913.54030.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-disposition: inline
User-Agent: KMail/1.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings;

Is there a utility that can query the motherboard bios and get a list of the 
drives it can see?

Likewise, for the bios extension contained on a pny sata card with a Silicon 
Image chipset on it?

I'm trying to cobble up a way for linux to boot from the drive on this sata 
card, so that the F8 install is completely separated from the FC6 install on 
a pata drive connected to the mainboard.

Thanks.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Alea iacta est.
	[The die is cast]
		-- Gaius Julius Caesar
