Return-Path: <linux-kernel-owner+w=401wt.eu-S1767685AbXECTEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767685AbXECTEJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 15:04:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767693AbXECTEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 15:04:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:51181 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767685AbXECTEG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 15:04:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] [POWERPC] 8xx: mpc885ads pcmcia support
Date: Thu, 3 May 2007 21:03:33 +0200
User-Agent: KMail/1.9.6
Cc: Segher Boessenkool <segher@kernel.crashing.org>,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20070503065435.4533.64938.stgit@localhost.localdomain> <200705030948.03984.arnd@arndb.de> <5a7e02f6d1520d8ad02e28ace218981c@kernel.crashing.org>
In-Reply-To: <5a7e02f6d1520d8ad02e28ace218981c@kernel.crashing.org>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705032103.33809.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19tOXzBORL29/Yk94JCSr4PzvZ8ShrmCUOjyq9
 LmLp+YRT3+LTxTCdErveRDCIZoTGlgtKNNquYPsk8u6PVb06Y0
 cztt1ZUmsxbkIYZgplubQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 May 2007, Segher Boessenkool wrote:
> > For example, you could make this
> >
> >       compatible = "8xx\0mpc885ads";
> 
> "mpc885ads-pcmcia\0mpc8xx-pcmcia" or something like that.

Right. I can never remember what goes first...

	Arnd <><
