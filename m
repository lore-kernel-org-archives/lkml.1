Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046AbXDWQx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbXDWQx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 12:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030285AbXDWQx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 12:53:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63764 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087AbXDWQx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 12:53:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 0/9] Kconfig: cleanup s390 v2.
Date: Mon, 23 Apr 2007 18:52:32 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       akpm@linux-foundation.org, mb@bu3sch.de, linville@tuxdriver.com,
       maxextreme@gmail.com, gregkh@suse.de
References: <20070423141123.GA21174@skybase>
In-Reply-To: <20070423141123.GA21174@skybase>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704231852.33599.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/QgJMD199UL+mSfjQp10hIXadJ0fMCq30fzHO
 /CPd9awGEHBTnudpue+Lra6Q0HZ++P0E6wpZHAv84hxkQhmtq0
 LlXecxIAeR7XWUZ8TgeDA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 April 2007, Martin Schwidefsky wrote:
> I've added the results of the review to the Kconfig cleanup patches
> for s390. Patch #2 has been split, one half has all the HAS_IOMEM
> depends lines the other the remaining !S390 depends lines.
> 

They all look good to me now
