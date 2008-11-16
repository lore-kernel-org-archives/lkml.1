Return-Path: <linux-kernel-owner+w=401wt.eu-S1755904AbYKPEGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbYKPEGO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 23:06:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbYKPEF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 23:05:57 -0500
Received: from smtp-out3.blueyonder.co.uk ([195.188.213.6]:55477 "EHLO
	smtp-out3.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751652AbYKPEF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 23:05:57 -0500
Message-ID: <491F9C22.1010006@blueyonder.co.uk>
Date: Sun, 16 Nov 2008 04:05:54 +0000
From: Sid Boyce <g3vbv@blueyonder.co.uk>
Reply-To: g3vbv@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: "do_IRQ: 0.189 No irq handler for vector" message and hard lockup
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I first had this happen on 15th with 2.6.28-rc4-git5 and reverted to
2.6.28-rc4-git2. Just as I was composing this email, it happened,
followed by a hard lockup after some bleeps about 30 secs. later.
At the time of this latest occurrence I was building 2.6.28-rc5.
I shall supply any further info deemed relevant.
Using openSUSE 11.1 Beta5.1 x86_64 on this box, the others are running
on stock openSUSE kernels at present.
One further effect, no keys are repeating after the latest hang.
Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

