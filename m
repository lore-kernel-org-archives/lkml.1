Return-Path: <linux-kernel-owner+w=401wt.eu-S1753356AbYHBFUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbYHBFUL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 01:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751606AbYHBFTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 01:19:55 -0400
Received: from ik-out-1112.google.com ([66.249.90.179]:39295 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbYHBFTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 01:19:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id:from;
        b=t3ctdCgdm+p99QFW/pSEWtZ2ts0GZPKX6dmvzgvXEywoHUQD7AcuRz76EEBuaQxwSx
         5xCvRymxQugsZQB/Z7glNXFU6VvnK/LZWtiOxSd6f3C19AyMkvsFrMTVDZw+vM6mXYSp
         Gpzv5LnmvqKlXv6VFgMfYlG4tsXrKNWC9q5f8=
To: David Miller <davem@davemloft.net>
Subject: Re: pull request: wireless-2.6 2008-08-01
Date: Sat, 2 Aug 2008 07:42:37 +0200
User-Agent: KMail/1.9.9
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080801205830.GA10071@tuxdriver.com> <20080801.221604.149076257.davem@davemloft.net>
In-Reply-To: <20080801.221604.149076257.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808020742.37575.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 August 2008, David Miller wrote:
> From: "John W. Linville" <linville@tuxdriver.com>
> Date: Fri, 1 Aug 2008 16:58:30 -0400
> 
> > Another big batch of wireless fixes for 2.6.27.  The ath5k series is
> > more than fixes, but I included it because it enables new ath5k
> > hardware.  (The ath5k.h changes in particular are documentation cleanups
> > for registers based on info gleaned from the newly posted ath9k driver.)
> > The others patches are fixes, some more obvious than others. :-)
> > 
> > Let me know if there are any problems!
> 
> Pulled and pushed out to net-2.6 on kernel.org
> 
> If someone could fix up this warning I'd appreciate it:
> 
> drivers/net/wireless/rt2x00/rt73usb.c: In function 'rt73usb_load_firmware':
> drivers/net/wireless/rt2x00/rt73usb.c:916: warning: passing argument 5 of 'rt2x00usb_vendor_request_large_buff' discards qualifiers from pointer target type

Patch coming up in a few minutes. :)

Ivo
