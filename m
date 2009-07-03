Return-Path: <linux-kernel-owner+w=401wt.eu-S1757397AbZGCNvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397AbZGCNvu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 09:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754701AbZGCNvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 09:51:42 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:62803 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553AbZGCNvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 09:51:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=P0hKZExqlwbHENnuz1lq3Jc5t/XRk8XtWvhH47IRQY+c5buz/gZXHCcDW4uE8m+x1h
         mIFdKbopLvKXG8qDITU9Yotm9jF8NZexMoYTr3jn5t1nLK24yDE/gERekRQ1IBp9oXBZ
         I6Cluap2uvmXyx2eu/7Uf3iO26qPG3A8eDQkE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] Staging: rtl8192su: add TODO
Date: Fri, 3 Jul 2009 15:57:44 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc1-next-20090703-03460-gb01c1b8; KDE/4.2.4; i686; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, linux-kernel@vger.kernel.org
References: <200906281740.50426.bzolnier@gmail.com> <20090702193326.GD10957@kroah.com>
In-Reply-To: <20090702193326.GD10957@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907031557.46345.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 July 2009 21:33:26 Greg KH wrote:
> On Sun, Jun 28, 2009 at 05:40:50PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> With all of your rtl8192su patches, I'm getting the following build
> error:
> 	ERROR: "ieee80211_xmit" [drivers/staging/rtl8192su/r8192s_usb.ko] undefined!
> 
> any ideas?

I cannot reproduce it here, please send me your kernel config.

PS I'll send you the rest of my overdue rtl8192su patches in few minutes.
