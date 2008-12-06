Return-Path: <linux-kernel-owner+w=401wt.eu-S1758258AbYLFHmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258AbYLFHmy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 02:42:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035AbYLFHmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 02:42:45 -0500
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1903 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbYLFHmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 02:42:45 -0500
Subject: Re: [RFC] Recursive printk
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Andrew <nick@nick-andrew.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tejun Heo <tj@kernel.org>, Takashi Iwai <tiwai@suse.de>
In-Reply-To: <20081205232016.366765e2.akpm@linux-foundation.org>
References: <20081206065922.29149.63380.stgit@marcab.local.tull.net>
	 <20081205232016.366765e2.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 05 Dec 2008 23:42:37 -0800
Message-Id: <1228549357.13046.618.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-12-05 at 23:20 -0800, Andrew Morton wrote:
> IOW, for this to be halfway as useful as you expect, we need a
> look-out-for-local-printk-hacks maintainer.

Which is really just a reviewer unless
the nominal maintainer is overridden.

I think recursive printk is poor style and
should be avoided.

