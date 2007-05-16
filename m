Return-Path: <linux-kernel-owner+w=401wt.eu-S1762653AbXEPUjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762653AbXEPUjg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 16:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757812AbXEPUj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 16:39:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51974 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756943AbXEPUj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 16:39:26 -0400
Date: Wed, 16 May 2007 21:39:17 +0100 (BST)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-usb-devel@lists.sourceforge.net,
       "art@usfltd.com" <art@usfltd.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       video4linux@list.redhat.com, Hans Verkuil <hverkuil@xs4all.nl>,
       Robert Fitzsimons <robfitz@273k.net>, netdev@vger.kernel.org,
       Auke Kok <auke-jan.h.kok@intel.com>, Doug Chapman <doug.chapman@hp.com>,
       Jeb Cramer <cramerj@intel.com>, John Ronciak <john.ronciak@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       e1000-devel@lists.sourceforge.net
Subject: Re: [3/3] 2.6.22-rc1: known regressions v2
In-Reply-To: <464B6A2F.9040605@googlemail.com>
Message-ID: <Pine.LNX.4.64.0705162136510.5580@pentafluge.infradead.org>
References: <464B6743.9000607@googlemail.com> <464B6895.60806@googlemail.com>
 <464B6A2F.9040605@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,


> V4L
>
> Subject    : V4L ABI breakage
> References : http://lkml.org/lkml/2007/5/14/42
> Submitter  : Robert Fitzsimons <robfitz@273k.net>
> Caused-By  : Hans Verkuil <hverkuil@xs4all.nl>
>             Mauro Carvalho Chehab <mchehab@infradead.org>
>             commit 206ebaf32795cf1582b1e2ff2ec6a560c9e986b8
> Status     : Unknown

We are currently working on it. I expect to have a patch fixing the issue 
until next week.

Cheers,
Mauro.
