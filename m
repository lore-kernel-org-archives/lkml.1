Return-Path: <linux-kernel-owner+w=401wt.eu-S1760652AbXIVACp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760652AbXIVACp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 20:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751249AbXIVACf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 20:02:35 -0400
Received: from baikonur.stro.at ([213.239.196.228]:4776 "EHLO baikonur.stro.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544AbXIVACe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 20:02:34 -0400
Date: Sat, 22 Sep 2007 02:02:30 +0200
From: maximilian attems <max@stro.at>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>, Denys Vlasenko <vda.linux@googlemail.com>,
       Valdis.Kletnieks@vt.edu, David Miller <davem@davemloft.net>,
       mchan@broadcom.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] bnx2: factor out gzip unpacker
Message-ID: <20070922000230.GF19918@baikonur.stro.at>
References: <200709211201.24475.vda.linux@googlemail.com> <200709211905.23946.vda.linux@googlemail.com> <15775.1190399812@turing-police.cc.vt.edu> <200709212018.06553.vda.linux@googlemail.com> <20070921220333.3b31afb5@the-village.bc.nu> <46F446C3.9050600@garzik.org> <20070921234805.478efe15@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070921234805.478efe15@the-village.bc.nu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 11:48:05PM +0100, Alan Cox wrote:
> > According to an earlier thread, dgrs was never really maintained, 
> > written for hardware that was never really distributed widely, and very 
> > likely hasn't had users in years... if ever.
> > 
> > If that picture is accurate (it's a story I was told), then I am 
> > definitely queueing up a deletion patch.
> 
> I think thats sensible. If someone whines it can be put back but I really
> don't think anyone will

nobody did yet, please yell if you need a rebased patch.

-- 
maks
