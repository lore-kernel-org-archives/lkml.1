Return-Path: <linux-kernel-owner+w=401wt.eu-S1756215AbZF1Nhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215AbZF1Nhf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 09:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756111AbZF1NhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 09:37:18 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:64637 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946AbZF1NhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 09:37:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=lPxyoRJWjR7r0rGLpqDc1k/QLnnr2c8YQgpP821HvWmKNqBqffgj8TDW0l8rLlodxp
         eH20nX7QSdTnF/m8nam1qsorFvRzbctWRm7kf9/DtJKxhi+fIYfxtCzLtSPhpT0AuU8l
         Al9rIMwvqCk3aTf8Os/B3UqzFZTq7091KyXgE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Forest Bond <forest@alittletooquiet.net>
Subject: Re: Staging: vt6656 ?
Date: Sun, 28 Jun 2009 15:43:12 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090623-11043-g1684859-dirty; KDE/4.2.3; i686; ; )
Cc: Greg KH <gregkh@suse.de>, Alexander Beregalov <a.beregalov@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <a4423d670906090331o6363fe56g34374967f21552e8@mail.gmail.com> <20090609105101.GB15378@suse.de> <20090609113343.GA13779@alittletooquiet.net>
In-Reply-To: <20090609113343.GA13779@alittletooquiet.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906281543.12745.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tuesday 09 June 2009 13:33:43 Forest Bond wrote:
> Hi,
> 
> On Tue, Jun 09, 2009 at 03:51:01AM -0700, Greg KH wrote:
> > On Tue, Jun 09, 2009 at 02:31:30PM +0400, Alexander Beregalov wrote:
> > > Hi Greg, Forest
> > > 
> > > Are you going to merge driver for VT6656 also?
> > 
> > If someone sends me some patches for it, sure, I will.
> 
> I have patches almost ready.  I'll send them by the end of next week at the
> latest.  Busy week here.

Did I miss the patch?  There are people already doing cleanups for VT6655
driver (which seems to share a great deal of code with VT6656 driver) so
it would greatly help to get VT6656 merged ASAP and merge the shared code
first to not duplicate efforts.

Also if you need some help with integrating the driver or hosting patches
in git tree at kernel.org before Greg picks them up [ he seems to be buried
alive by patches at the moment :) ] I'll be happy to help..

Thanks,
Bart
