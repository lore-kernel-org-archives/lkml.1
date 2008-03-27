Return-Path: <linux-kernel-owner+w=401wt.eu-S1759458AbYC0Oxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759458AbYC0Oxn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 10:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbYC0Oxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 10:53:34 -0400
Received: from mail.station1.mxsweep.com ([212.147.136.149]:2586 "EHLO
	mail2.mxsweep.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752772AbYC0Oxd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 10:53:33 -0400
Message-ID: <47EBB4BC.7040509@draigBrady.com>
Date: Thu, 27 Mar 2008 14:52:44 +0000
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25: something wrong with ^C
References: <20080327142814.GC13190@elf.ucw.cz>
In-Reply-To: <20080327142814.GC13190@elf.ucw.cz>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 27 Mar 2008 14:52:44.0766 (UTC) FILETIME=[3713E7E0:01C8901A]
x-MXSweep-CtasdSpam: Unknown
x-MXSweep-CtasdVirus: Unknown
x-MXSweep-KeywordsCount: 0
x-MXPurifier-SpamScore: 0
x-MXPurifier-VirusScore: 0
X-MXSweep-Threat: Clean
X-MXUniqueID: 02f9e76e-51ee-4807-b0c0-ff3ab6387530
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
> Is it just me, or does ^C take longer in 2.6.25?
> 
> Like... one second delay between pressing ^C and seeing any effect?

It can join Ctrl-\ on ubuntu so:
https://bugs.launchpad.net/bugs/62511

Pádraig.
