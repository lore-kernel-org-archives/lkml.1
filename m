Return-Path: <linux-kernel-owner+w=401wt.eu-S1751906Ab0ARFsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab0ARFsN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 00:48:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750764Ab0ARFsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 00:48:12 -0500
Received: from 175.210.DSNET ([203.110.175.210]:43021 "EHLO mail.atheros.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750751Ab0ARFsL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 00:48:11 -0500
X-Greylist: delayed 324 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Jan 2010 00:48:11 EST
From: Jie Yang <Jie.Yang@Atheros.com>
To: =?iso-8859-1?Q?Alejandro_Riveira_Fern=E1ndez?= <ariveira@gmail.com>,
       =?iso-8859-1?Q?Anders_Bostr=F6m?= <anders@netinsight.net>
CC: Xiong Huang <Xiong.Huang@Atheros.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ben@decadent.org.uk" <ben@decadent.org.uk>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date: Mon, 18 Jan 2010 13:42:43 +0800
Subject: RE: atl1e: TSO is broken
Thread-Topic: atl1e: TSO is broken
Thread-Index: AcqV+x1GwINZivUyRYyX8oXlb1pbAQCBbuNQ
Message-ID: <72981EBCFD196144B7C6999B9FC34A9A49508C6376@SHEXMB-01.global.atheros.com>
References: <20100115.135613.1130385479658158300.anders@netinsight.net>
 <20100115165447.2eb7d547@varda>
In-Reply-To: <20100115165447.2eb7d547@varda>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 15, 2010 11:55 PM
Alejandro Riveira Fernández <ariveira@gmail.com> wrote:
> > Short desription
> > ----------------
> >
> > TCP Segmentation Offload (TSO) result in broken
> IPv4-packets sent out
> > from Atheros AR8121/AR8113/AR8114 with the atl1e driver.
> >
> >
> > Work around
> > -----------
> >
> > Turn off TSO. Requires 2.6.33-rc1 or later.
> >
> >

Ok, I will try to reproduce it first.

Best wishes
jie
