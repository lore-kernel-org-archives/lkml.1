Return-Path: <linux-kernel-owner+w=401wt.eu-S1757273AbZBKX2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbZBKX2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 18:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755536AbZBKX2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 18:28:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50501 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755325AbZBKX2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 18:28:03 -0500
Date: Wed, 11 Feb 2009 15:27:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Cc: linux-kernel@vger.kernel.org, eric.piel@tremplin-utc.net, pavel@suse.cz
Subject: Re: [PATCHv7] lis3lv02d: support both one- and two-byte sensors
Message-Id: <20090211152724.47f0c230.akpm@linux-foundation.org>
In-Reply-To: <cb7bb73a0902111506u5fca742fq985870e1b5fd8515@mail.gmail.com>
References: <49929EB8.4020802@tremplin-utc.net>
	<1234346803-19811-1-git-send-email-giuseppe.bilotta@gmail.com>
	<20090211143844.27ca0d6c.akpm@linux-foundation.org>
	<cb7bb73a0902111444h46be9b65pa01d4b2b9c31afe8@mail.gmail.com>
	<20090211145355.7b3d060d.akpm@linux-foundation.org>
	<cb7bb73a0902111506u5fca742fq985870e1b5fd8515@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Feb 2009 00:06:41 +0100
Giuseppe Bilotta <giuseppe.bilotta@gmail.com> wrote:

> On Wed, Feb 11, 2009 at 11:53 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Wed, 11 Feb 2009 23:44:20 +0100
> > Giuseppe Bilotta <giuseppe.bilotta@gmail.com> wrote:
> >>
> >> I based my patch on Linus' tree, plus Pavel's patch which I've been
> >> told is on your tree.
> >
> > What is "Pavel's patch"?  Pavel writes lots of patches :(
> 
> Right, sorry. This one:
> 
> http://userweb.kernel.org/~akpm/mmotm/broken-out/hp-accelerometer-add-freefall-detection.patch

oh.  I wouldn't have guessed.

> Thanks for the link to mmotm, btw.
> 
> I noticed that the patch check complained about the misaligned switch.

I fixed that up.

> Do you want me to resend it with the shifted block?

Is ok, thanks.
