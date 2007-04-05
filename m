Return-Path: <linux-kernel-owner+w=401wt.eu-S1767364AbXDEV4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767364AbXDEV4t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 17:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767366AbXDEV4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 17:56:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:58779 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767364AbXDEV4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 17:56:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Hourihane <alanh@fairlite.demon.co.uk>
Subject: Re: [PATCH 01/01] New FBDev driver for Intel Vermilion Range
Date: Thu, 5 Apr 2007 23:56:42 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <1175769886.10382.29.camel@localhost> <200704052138.08897.arnd@arndb.de> <1175809336.10105.54.camel@jetpack.demon.co.uk>
In-Reply-To: <1175809336.10105.54.camel@jetpack.demon.co.uk>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704052356.43331.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19gVkKkl010/XEASI5mLuaTJu7ZsBEcRK76PwV
 iEdvEgb9pVeH2IJRf43EoaY+DRM6LR9woFl36dcvr3WMeNmQts
 1+4Oj1QZfY3V2FWnI4f/Q==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 April 2007, Alan Hourihane wrote:
> As for the above, I've noticed that drivers/video/epson1355fb.c also has
> this wording and is under the GPL.

Yes, many files have it, but that doesn't make it right ;-)

	Arnd <><
