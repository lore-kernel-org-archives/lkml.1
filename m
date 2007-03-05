Return-Path: <linux-kernel-owner+w=401wt.eu-S932264AbXCEILK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264AbXCEILK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 03:11:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932272AbXCEILK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 03:11:10 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:56099 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264AbXCEILJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 03:11:09 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: bryan.wu@analog.com
Subject: Re: [PATCH -mm 1/5] Blackfin: blackfin architecture patch update
Date: Mon, 5 Mar 2007 09:10:55 +0100
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <1172722480.5264.75.camel@roc-desktop> <200703032330.50116.arnd@arndb.de> <1173080091.5264.178.camel@roc-desktop>
In-Reply-To: <1173080091.5264.178.camel@roc-desktop>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703050910.55491.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX1/LgkcGDbPKaglyiMP+E8CHIJdPKO5USsyEF3S
 vrsEbIauB37EhExPvVnOe4FOWF0j7sRqDOrTF83w26Md9Mq322
 ExovMdOBX7B2KEXyad/TQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 March 2007, Wu, Bryan wrote:
 
> So could please give us some information about the merge window
> schedule, we may try to catch this.
 
The merge window opens after 2.6.21 gets released and is open for
two weeks aftre that. The idea is however that you have everything
ready at the start of the merge window.

> Oh, if we should fix this issue, there are lots of work to do because
> tons of drivers rely on this. Maybe after some team internal discussion,
> we will give a solution to this.

You can probably use a short perl script (or similar) to automate the
conversion.

	Arnd <><
