Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbXHGHR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbXHGHR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 03:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754763AbXHGHRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 03:17:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:58432 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757348AbXHGHRq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 03:17:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Nathan Williams" <ngwilliams@gmail.com>
Subject: Re: MODULE_LICENSE usage
Date: Tue, 7 Aug 2007 09:17:38 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel <linux-kernel@vger.kernel.org>
References: <b4e196fa0708060053x65f0b1d3m50c62206cb65e016@mail.gmail.com> <MDEHLPKNGKAHNMBLJOLKOEOJFOAC.davids@webmaster.com> <b4e196fa0708062029x681fafe7hc493c774a936cdf3@mail.gmail.com>
In-Reply-To: <b4e196fa0708062029x681fafe7hc493c774a936cdf3@mail.gmail.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708070917.39436.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/Shk2+RJBwEXvFWzeizuy4kigbvn1EBLnMPkK
 YHC3ZiiAAjPmmcjRNPd9I0o1+mtdQzfzgBhu6KuD2H/bQLED0J
 VeZ3GMe5JF7jpEEkGFLUw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 August 2007, Nathan Williams wrote:
> My company has been given documentation and the library source under
> the terms of an NDA with the chipset manufacturer.  We are permitted
> to compile the library and distribute the resultant binary blob, but
> not release the source to the library.

Are you permitted to use the documentation to produce a free driver
that is not derived from the closed source code? That would put you
legally on the safe side and make a lot of your customers happy.

	Arnd <><
