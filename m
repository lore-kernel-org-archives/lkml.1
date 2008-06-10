Return-Path: <linux-kernel-owner+w=401wt.eu-S1759536AbYFJWEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759536AbYFJWEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 18:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758940AbYFJWEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 18:04:33 -0400
Received: from mail-sin.bigfish.com ([207.46.51.74]:53960 "EHLO
	mail75-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758914AbYFJWEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 18:04:32 -0400
X-Greylist: delayed 1737 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Jun 2008 18:04:31 EDT
X-BigFish: VPS-9(zz98dRzz10d3izzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.75;Service: EHS
Message-ID: <484EF323.7000809@am.sony.com>
Date: Tue, 10 Jun 2008 14:33:23 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: execute bit on scripts (was Re: [PATCH] add diffconfig utility)
References: <484ED902.9040000@am.sony.com> <20080610210217.GA2432@logfs.org> <20080610211841.GA23855@uranus.ravnborg.org>
In-Reply-To: <20080610211841.GA23855@uranus.ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Jun 2008 21:35:12.0420 (UTC) FILETIME=[DD2EBE40:01C8CB41]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> I will merge it if the feedabck is positive and eventual feedback
> is dealt with. (And Tim reminds me to do so in a week or so).

Thanks.

> I take most of the random scripts in scripts/ via kbuild.git.

OK - sounds like you're the right person to ask a question
that has been nagging me.

Is there a proper way to get the execute bit set in the git tree
on  patches that contain scripts?  I think patches
produced by git have something that sets the file permissions?
Is this something that can (or should) be hand-added to
a non-git patch? (I use quilt).

I put that blurb in the patch description about doing a
'chmod a+x', but that doesn't seem reliable.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

