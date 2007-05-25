Return-Path: <linux-kernel-owner+w=401wt.eu-S1764300AbXEYQvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764300AbXEYQvL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 12:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762926AbXEYQu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 12:50:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59229 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761248AbXEYQu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 12:50:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [patch 6/7] ps3: ROM Storage Driver
Date: Fri, 25 May 2007 18:50:29 +0200
User-Agent: KMail/1.9.6
Cc: Geert.Uytterhoeven@sonycom.com, linux-kernel@vger.kernel.org
References: <20070525083607.784351000@sonycom.com> <20070525083632.677742000@sonycom.com>
In-Reply-To: <20070525083632.677742000@sonycom.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705251850.30342.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+MStpKhD5s72FiogDG8OT4zks54RP4tvpDbXt
 gmF2sDjSYwBwWcg8D+Otz1X3KxYfjCqXULAKgz8o8e126AlrPh
 OYbhbwJyenjStLyHow/BA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 May 2007, Geert.Uytterhoeven@sonycom.com wrote:
> Add a CD/DVD/BD Storage Driver for the PS3:
>   - Implemented as a SCSI device driver

I assume you tried implementing it as a block device driver,
like you PS3 disk driver does, and failed for some reason.

What is the problem? Is there infrastructure missing in the
CD-ROM layer?

	Arnd <><
