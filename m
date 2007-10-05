Return-Path: <linux-kernel-owner+w=401wt.eu-S1761816AbXJEMs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761816AbXJEMs3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 08:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755605AbXJEMsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 08:48:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:52128 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011AbXJEMsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 08:48:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] block: move ioctl conversion to compat_blkdev_ioctl
Date: Fri, 5 Oct 2007 14:41:58 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, hch@lst.de,
       Al Viro <viro@ftp.linux.org.uk>
References: <20071002073943.GC5236@kernel.dk> <200710051430.39792.arnd@arndb.de> <20071005124153.GT5711@kernel.dk>
In-Reply-To: <20071005124153.GT5711@kernel.dk>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710051441.59012.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/ccetYqcuRdpbXnYcC/yEYQWtQPrMIoAv76Hr
 JZL3n93RL5mB1s7PpAFSuxpqOJyBPRsyAfDIT1vfKmEtsPYsNR
 nH0N6C/iYR+oS9VrUHwjg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 October 2007, Jens Axboe wrote:
> As before, this looks pretty good. I'll toss it in the tester and see if
> things still work.
> 

Ok, thanks a lot.

	Arnd <><
