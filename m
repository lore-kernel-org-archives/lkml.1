Return-Path: <linux-kernel-owner+w=401wt.eu-S933689AbXHHW6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933689AbXHHW6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 18:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761895AbXHHW57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 18:57:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55808 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761114AbXHHW56 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 18:57:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: =?utf-8?q?J=C3=B6rn_Engel?= <joern@logfs.org>
Subject: Re: [Patch 02/18] include/linux/logfs.h
Date: Thu, 9 Aug 2007 00:56:29 +0200
User-Agent: KMail/1.9.6
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       David Woodhouse <dwmw2@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20070808161234.GB15319@lazybastard.org> <20070808161428.GD15319@lazybastard.org>
In-Reply-To: <20070808161428.GD15319@lazybastard.org>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708090056.30350.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+Hy4nb34S0Ys+1/AxCx2vH/yjmWYB3n8LVydF
 cQp85KDejMpjEAwNZRAQ116c6w2RCmrGfLF/hijeAvOwKCGhUO
 Nj31S2tpq/fB5LgkNKkEw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 August 2007, Jörn Engel wrote:
> +++ linux-2.6.21logfs/include/linux/logfs.h     2007-08-08 02:57:37.000000000 +0200
> @@ -0,0 +1,500 @@
> +/*
> + * fs/logfs/logfs.h
> + *

The comment does not match the file name. Better remove the file names
entirely from introduction comments.

	Arnd <><
