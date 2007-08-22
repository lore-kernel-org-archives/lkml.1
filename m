Return-Path: <linux-kernel-owner+w=401wt.eu-S934315AbXHVR0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934315AbXHVR0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 13:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764386AbXHVR0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 13:26:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:65517 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764380AbXHVR0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 13:26:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: paulus@samba.org
Subject: git tree, Re: [patch 0/5] (hopefully) final 2.6.23 fixes for cell platform
Date: Wed, 22 Aug 2007 19:15:12 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       cbe-oss-dev@ozlabs.org
References: <20070822170124.764128591@arndb.de>
In-Reply-To: <20070822170124.764128591@arndb.de>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708221915.12355.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19SXy1hiCHZRJQlaZWxDsqRxtvgbhd3H1LCMbw
 mWRwhGQrIHrresS0F7mQJw5X7oCfd64W1k245U7VzaWRWLKQJ9
 zkJBS+hMLTUhiyz1NyPFQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 August 2007, Arnd Bergmann wrote:
> Hi Paul,
> 
> A few bugs came up on the cell platform when testing on the lastest
> prototype version of a future hardware. The first three patches are
> all meant to track changes required for the fixes that have gone
> into the firmware. Patch 4 is for a bug that showed up during testing,
> and the final patch is the defconfig update that you probably want
> to do for the other platforms as well.
> 
> Please forward for inclusion in 2.6.23!

If you prefer the git tree, please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/arnd/cell-2.6.git for-2.6.23

	Arnd <><
