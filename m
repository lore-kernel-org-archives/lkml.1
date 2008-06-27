Return-Path: <linux-kernel-owner+w=401wt.eu-S1756420AbYF0FZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420AbYF0FZB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 01:25:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbYF0FYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 01:24:51 -0400
Received: from 175.210.dsnet ([203.110.175.210]:40770 "EHLO mail.atheros.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751328AbYF0FYu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 01:24:50 -0400
From: Jie Yang <Jie.Yang@Atheros.com>
To: Jay Cliburn <jacliburn@bellsouth.net>
CC: "jeff@garzik.org" <jeff@garzik.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date: Fri, 27 Jun 2008 13:24:47 +0800
Subject: RE: [PATCH 2.6.25.3 1/5] atl1e: Atheros L1E Gigabit Ethernet driver
Thread-Topic: [PATCH 2.6.25.3 1/5] atl1e: Atheros L1E Gigabit Ethernet driver
Thread-Index: AcjX/+W/vqXl3M89TQir/VNpGaFi9wAFSynA
Message-ID: <72981EBCFD196144B7C6999B9FC34A9A3EE603BB7C@SHEXMB-01.global.atheros.com>
References: <72981EBCFD196144B7C6999B9FC34A9A3EE603B863@SHEXMB-01.global.atheros.com>
 <20080626214510.01373505@osprey.hogchain.net>
In-Reply-To: <20080626214510.01373505@osprey.hogchain.net>
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

From: Jay Cliburn [acliburn@bellsouth.net]
Date: Friday, June 27, 2008 10:45 AM

> Patches 1 and 2 reviewed tonight.  I intend to review the
> other 3 in coming days.

Thanks for your help.
I will update source code on these comments.

> On Thu, 26 Jun 2008 13:37:23 +0800
> Jie Yang <Jie.Yang@Atheros.com> wrote:
>
> > From: Jie Yang <jie.yang@atheros.com>
> >
> > Full patch for the Atheros L1E Gigabit Ethernet driver.
> > Supportring AR8121, AR8113 and AR8114
>
> Please generate the patch against current mainline (or at
> least current -rc); it fails to apply cleanly as is.
>

how about use the git
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git

Best wishes
jie
