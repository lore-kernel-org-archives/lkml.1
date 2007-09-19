Return-Path: <linux-kernel-owner+w=401wt.eu-S1752291AbXISBFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbXISBFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 21:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750910AbXISBFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 21:05:43 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:20522 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbXISBFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 21:05:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dT9fqdQBL9Xw1t6MdpPWKl+AYXZzkK1Zsbc2VvYk5A/2qcLnXIM26dTGmNyttHZV9N2oOVUloD/TDI27ehSOykcolyIxCXcBl97dsAg4RA0Y4XXTZRjsdvpTHAxAVkSOZElqjs1S3x+w+sku7Y2sSGxbHlfb+lljblZHAIQn+zs=
Message-ID: <a44ae5cd0709181805v59e12871j9cc2e5f2332b40c2@mail.gmail.com>
Date: Tue, 18 Sep 2007 21:05:40 -0400
From: "Miles Lane" <miles.lane@gmail.com>
To: "mkrufky@linuxtv.org" <mkrufky@linuxtv.org>
Subject: Re: [v4l-dvb-maintainer] 2.6.23-rc6-mm1 -- "dvb_dmx_swfilter" [dr ivers/media/video/video-buf-dvb.ko] undefined!
Cc: akpm@linux-foundation.org, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <46F01A39.3010104@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a44ae5cd0709181117k7a563e66y8e01a64e5877cac8@mail.gmail.com>
	 <46F01A39.3010104@linuxtv.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/18/07, mkrufky@linuxtv.org <mkrufky@linuxtv.org> wrote:
> Miles Lane wrote:
> > ERROR: "dvb_dmx_swfilter" [drivers/media/video/video-buf-dvb.ko]
> undefined!
> > ERROR: "dvb_net_init" [drivers/media/video/video-buf-dvb.ko] undefined!
> > ERROR: "dvb_dmxdev_init" [drivers/media/video/video-buf-dvb.ko] undefined!
> > ERROR: "dvb_dmx_init" [drivers/media/video/video-buf-dvb.ko] undefined!
> > ERROR: "dvb_register_frontend" [drivers/media/video/video-buf-dvb.ko]
> undefined!
> > ERROR: "dvb_register_adapter" [drivers/media/video/video-buf-dvb.ko]
> undefined!
> > ERROR: "dvb_unregister_adapter" [drivers/media/video/video-buf-dvb.ko]
> > undefined!
> > ERROR: "dvb_frontend_detach" [drivers/media/video/video-buf-dvb.ko]
> undefined!
> > ERROR: "dvb_unregister_frontend"
> > [drivers/media/video/video-buf-dvb.ko] undefined!
> > ERROR: "dvb_dmx_release" [drivers/media/video/video-buf-dvb.ko] undefined!
> > ERROR: "dvb_dmxdev_release" [drivers/media/video/video-buf-dvb.ko]
> undefined!
> > ERROR: "dvb_net_release" [drivers/media/video/video-buf-dvb.ko] undefined!
> > ERROR: "mt2131_attach" [drivers/media/video/cx23885/cx23885.ko] undefined!
> > ERROR: "s5h1409_attach" [drivers/media/video/cx23885/cx23885.ko]
> undefined!
> >
>
> The attached fix should fix the problem.

Thanks!  Looks good here.

         Miles
