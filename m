Return-Path: <linux-kernel-owner+w=401wt.eu-S1758045AbYDCQ7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045AbYDCQ7q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 12:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753466AbYDCQ7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 12:59:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56165 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751566AbYDCQ71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 12:59:27 -0400
Date: Thu, 3 Apr 2008 09:59:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Dave Airlie" <airlied@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc8-mm1
Message-Id: <20080403095924.964a9436.akpm@linux-foundation.org>
In-Reply-To: <21d7e9970804030511w64232e65x822c72d70707ef6@mail.gmail.com>
References: <20080401213214.8fbb6d6b.akpm@linux-foundation.org>
	<21d7e9970804030511w64232e65x822c72d70707ef6@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Apr 2008 22:11:30 +1000 "Dave Airlie" <airlied@gmail.com> wrote:

> On Wed, Apr 2, 2008 at 2:32 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> >  ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc8/2.6.25-rc8-mm1/
> >
> >  - Added the wm97xx touchscreen driver tree, as git-wm97xx.patch (Mark Brown
> >   <broonie@opensource.wolfsonmicro.com>)
> >
> >  - git-alsa.patch has been replaced by git-alsa-tiwai.patch
> >
> >  - git-drm.patch is dropped due to build errors
> >
> Actually git-agp.patch is broken, and should have been dropped. the
> drm patch is fine.
> 
> I did mention this to you in two separate e-mails :)
> 

git-drm has a bunch of git rejects against mainline.  I had a go at fixing
them but it didn't work out and I had other stuff to look at.
