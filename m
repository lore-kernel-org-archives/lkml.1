Return-Path: <linux-kernel-owner+w=401wt.eu-S1760824AbXHWREs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760824AbXHWREs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 13:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbXHWREj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 13:04:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:51805 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbXHWREi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 13:04:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: kou.ishizaki@toshiba.co.jp
Subject: Re: [Cbe-oss-dev] [patch 1/5] spu_manage: use newer physical-id
Date: Thu, 23 Aug 2007 18:12:19 +0200
User-Agent: KMail/1.9.6
Cc: paulus@samba.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       jk@ozlabs.org, cbe-oss-dev@ozlabs.org
References: <20070823.180152.-1300528381.kouish@swc.toshiba.co.jp>
In-Reply-To: <20070823.180152.-1300528381.kouish@swc.toshiba.co.jp>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?iso-8859-15?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?iso-8859-15?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!D?=
 =?iso-8859-15?q?xZ=0A=098MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?iso-8859-15?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ?=
 =?iso-8859-15?q?=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?iso-8859-15?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200708231812.20493.arnd@arndb.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19rXis/mifT3Vi5hS2RNBHnwb4fxiXpjXNNs7l
 JnMvaPkzJC9m5SOMD7m0fEw9M7i/Z2Oh0aYKtJtEx+KAHffzhA
 /WPC0iMueFF7NAjDj1U5A==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 August 2007, kou.ishizaki@toshiba.co.jp wrote:
> Please check "unit-id" if "physical-id" doesn't exist. Because Celleb
> uses "unit-id" to provide spe_id.

Ok, I need to discuss this with Christian then, to make sure we get to
a version that works everywhere. Paul, please ignore this patch for now.

I've update the git repository to only have the other four patches.

	Arnd <><
