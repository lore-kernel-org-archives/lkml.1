Return-Path: <linux-kernel-owner+w=401wt.eu-S933666AbXDFRfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933666AbXDFRfm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 13:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933640AbXDFRfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 13:35:42 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:50796 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933666AbXDFRfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 13:35:41 -0400
Date: Fri, 6 Apr 2007 19:35:05 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Martin Bligh <mbligh@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] leave loglevel at 7 through sysrq output so you can
 actually read it
In-Reply-To: <Pine.LNX.4.64.0704061903360.14457@scrub.home>
Message-ID: <Pine.LNX.4.64.0704061933310.14458@scrub.home>
References: <46157DD2.4050502@google.com> <Pine.LNX.4.64.0704061830401.14458@scrub.home>
 <4616765C.3050509@google.com> <Pine.LNX.4.64.0704061903360.14457@scrub.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 6 Apr 2007, Roman Zippel wrote:

> > I did test the patch, and it works fine.
> 
> Did you check /proc/sys/kernel/printk?

BTW for even more fun check this with "echo 4 > /proc/sys/kernel/sysrq".

bye, Roman
