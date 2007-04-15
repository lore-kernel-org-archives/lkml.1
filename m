Return-Path: <linux-kernel-owner+w=401wt.eu-S1752000AbXDOC5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbXDOC5R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 22:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbXDOC5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 22:57:17 -0400
Received: from smtp-out2.blueyonder.co.uk ([195.188.213.5]:47460 "EHLO
	smtp-out2.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752000AbXDOC5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 22:57:16 -0400
Message-ID: <46219486.3030102@blueyonder.co.uk>
Date: Sun, 15 Apr 2007 03:57:10 +0100
From: Sid Boyce <g3vbv@blueyonder.co.uk>
Reply-To: g3vbv@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc5 possible regression: KDE processes die silently [fixed]
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am 03.04.2007 00:50 schrieb Adrian Bunk:
 >>/ We also have one bug kwin ran into that got fixed after -rc5:/
 >>/ /
 >>/ Subject : kwin dies silently/
 >>/ References : http://lkml.org/lkml/2007/2/28/112/
 >>/ Submitter : Sid Boyce <g3vbv@xxxxxxxxxxxxxxxx>/
 >>/ Boris Mogwitz <boris@xxxxxxxxxxxxxxxx>/
 >>/ Michael Wu <aluminum.tape@xxxxxxxxx>/
 >>/ Caused-By : Eric W. Biederman <ebiederm@xxxxxxxxxxxx>/
 >>/ commit 0475ac0845f9295bc5f69af45f58dff2c104c8d1/
 >>/ Fixed-By : Eric W. Biederman <ebiederm@xxxxxxxxxxxx>/
 >>/ Commit : 14e9d5730adfca26452b3a2838a80af6950556f5/
 >>/ Status : fixed in -rc6/
 >>
 > The machine has been running -rc5-git12, then -rc6 for a total
 > of four days now, and the problem hasn't reoccurred. Looks like
 > it was indeed the same bug.
 >
 > Thanks,
 > Tilman

No further problems since the patch was applied. Currently running 
2.6.21-rc6-git7.
Regards
Sid.

-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks


