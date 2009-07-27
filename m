Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbZG0WTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbZG0WTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 18:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754549AbZG0WTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 18:19:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36890 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754181AbZG0WTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 18:19:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [Bug #13665] commit 69c854817566 causes OOMs
Date: Tue, 28 Jul 2009 00:19:34 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc4-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       MinChan Kim <minchan.kim@gmail.com>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
References: <Jya1GruKQpD.A.16.2GObKB@chimera> <3zAHs5O6maO.A.44E.QIObKB@chimera> <20090727004851.GA10495@localhost>
In-Reply-To: <20090727004851.GA10495@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907280019.35927.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 July 2009, Wu Fengguang wrote:
> On Mon, Jul 27, 2009 at 04:28:20AM +0800, Rafael J. Wysocki wrote:
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13665
> > Subject		: commit 69c854817566 causes OOMs
> > Submitter	: David Howells <dhowells@redhat.com>
> > Date		: 2009-06-27 08:12 (30 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=69c854817566db82c362797b4a6521d0b00fe1d8
> > References	: http://lkml.org/lkml/2009/6/27/28
> 
> Both patches from KOSAKI and Rik can fix the OOM in my tests:
> 
> http://lkml.org/lkml/2009/7/7/104
> http://patchwork.kernel.org/patch/34740/
> 
> The latter one has been included in -mm
> 
> > Handled-By	: Wu Fengguang <fengguang.wu@intel.com>
> > Patch		: http://patchwork.kernel.org/patch/32740/
> 
> This patch is also in -mm.

Thanks, updated.

Rafael
