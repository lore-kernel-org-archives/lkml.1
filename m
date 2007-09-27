Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbXI0LpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbXI0LpM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 07:45:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027AbXI0LpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 07:45:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:59764 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbXI0Lo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 07:44:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 4/5] ibmebus: Move to of_device and of_platform_driver, match eHCA and eHEA drivers
Date: Thu, 27 Sep 2007 13:31:01 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070831.706792)
Cc: Joachim Fenkes <fenkes@de.ibm.com>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>, Thomas Klein <tklein@de.ibm.com>,
       Paul Mackerras <pmac@au1.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200709261143.24735.fenkes@de.ibm.com> <200709261145.51926.fenkes@de.ibm.com>
In-Reply-To: <200709261145.51926.fenkes@de.ibm.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709271331.02715.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/sex8pvxv6JQxibpDoM/HCx9by3iWkm3X2qke
 aeJGTP+aoPB/zbbKDoffg0ihyiO+btXPr2u34ym6pvA4sVYd2i
 i76LtB7eoENz+Na9G/KWw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 September 2007, Joachim Fenkes wrote:
> Replace struct ibmebus_dev and struct ibmebus_driver with struct of_device
> and struct of_platform_driver, respectively. Match the external ibmebus
> interface and drivers using it.
> 
> Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
