Return-Path: <linux-kernel-owner+w=401wt.eu-S1756809AbZGBURK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809AbZGBURK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 16:17:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754715AbZGBUQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 16:16:24 -0400
Received: from kroah.org ([198.145.64.141]:38492 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754182AbZGBUQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 16:16:23 -0400
Date: Thu, 2 Jul 2009 12:50:11 -0700
From: Greg KH <greg@kroah.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alexander Beregalov <a.beregalov@gmail.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, Forest Bond <forest@alittletooquiet.net>
Subject: Re: [PATCH] Staging: vt6655: s/VOID/void/
Message-ID: <20090702195011.GG10957@kroah.com>
References: <1245520957-22234-1-git-send-email-a.beregalov@gmail.com>
 <200907021946.08452.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907021946.08452.bzolnier@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 02, 2009 at 07:46:08PM +0200, Bartlomiej Zolnierkiewicz wrote:
> On Saturday 20 June 2009 20:02:37 Alexander Beregalov wrote:
> > Cc: Forest Bond <forest@alittletooquiet.net>
> > Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
> 
> Looks OK but (in the light of possible vt665{5,6} unification) it should be
> also done for vt6656, or alternatively (which is what I would personally
> prefer) delayed till more complete removal of ttype.h typedefs from vt665x.

I agree, it should be done for both drivers now that they are in
linux-next.

thanks,

greg k-h
