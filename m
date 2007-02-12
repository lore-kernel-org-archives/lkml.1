Return-Path: <linux-kernel-owner+w=401wt.eu-S965037AbXBLRwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965037AbXBLRwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 12:52:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965039AbXBLRwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 12:52:22 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:56718 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965037AbXBLRwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 12:52:21 -0500
Date: Mon, 12 Feb 2007 18:49:39 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Dave Jones <davej@redhat.com>
cc: Valerie Henson <val_henson@linux.intel.com>,
       Michael Kerrisk <mtk-manpages@gmx.net>, val_henson@linux.interl.com,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Documenting MS_RELATIME
In-Reply-To: <20070212154010.GC7617@redhat.com>
Message-ID: <Pine.LNX.4.61.0702121848480.26360@yvahk01.tjqt.qr>
References: <45CE0737.6010103@gmx.net> <20070211005400.GC6849@redhat.com>
 <20070212065503.GC20919@nifty> <20070212154010.GC7617@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Feb 12 2007 10:40, Dave Jones wrote:
> > > Whilst on the subject of RELATIME, is there any good reason why
> > > not to make this a default mount option ?
> > 
> > Ubuntu has been shipping with noatime as the default for some time
> > now, with no obvious problems (I'm running Ubuntu).  I see relatime as
> > an improvement on noatime.
>
>The one problem with noatime is that mutt's 'new mail arrived' breaks

Just why does not it use mtime then to check for New Mail Arrived, like 
bash does?


Jan
-- 
ft: http://freshmeat.net/p/chaostables/
