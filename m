Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbZLBIeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbZLBIeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 03:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbZLBIeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 03:34:16 -0500
Received: from 175.210.DSNET ([203.110.175.210]:31106 "EHLO mail.atheros.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754459AbZLBIeP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 03:34:15 -0500
From: Jie Yang <Jie.Yang@Atheros.com>
To: David Miller <davem@davemloft.net>
CC: "ben@decadent.org.uk" <ben@decadent.org.uk>,
       "558426@bugs.debian.org" <558426@bugs.debian.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 2 Dec 2009 16:34:18 +0800
Subject: RE: [PATCH net-next]atl1e:disable NETIF_F_TSO6 for hardware limit
Thread-Topic: [PATCH net-next]atl1e:disable NETIF_F_TSO6 for hardware limit
Thread-Index: AcpzKej2BsXibJmkRhm2vIrOFx9a5wAACP3Q
Message-ID: <72981EBCFD196144B7C6999B9FC34A9A494C6DABC3@SHEXMB-01.global.atheros.com>
References: <1259723914457-git-send-email-jie.yang@atheros.com>
 <20091202.003151.77443093.davem@davemloft.net>
In-Reply-To: <20091202.003151.77443093.davem@davemloft.net>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 02, 2009 4:32 PM
David Miller <davem@davemloft.net> wrote:
>
> From: <jie.yang@atheros.com>
> Date: Wed, 2 Dec 2009 11:18:34 +0800
>
> > From: Jie Yang <jie.yang@atheros.com>
> >
> > For hardware limit to support TSOV6, just disable this feature
> > Signed-off-by: Jie Yang <jie.yang@atheros.com>
>
> Shouldn't we be applying this to net-2.6 since it's a bug fix?
>
oh, It should applying to net-2.6.
