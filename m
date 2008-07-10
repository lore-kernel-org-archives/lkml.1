Return-Path: <linux-kernel-owner+w=401wt.eu-S1758255AbYGJPZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255AbYGJPZi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 11:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755424AbYGJPZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 11:25:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55090 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755594AbYGJPZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 11:25:29 -0400
Subject: [PATCH 00/15] Updated V5 - voltage regulator framework
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Thu, 10 Jul 2008 16:25:27 +0100
Message-Id: <1215703527.13431.56.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an updated version of the kernel voltage & current regulator
framework for SoC devices. It's being resent for re-review. The only
major difference between V4 and this version is the inclusion of some
new sysfs entries for retrieving regulator suspend state information
(patch 14/15) and a MAINTAINERS entry (patch 15/15).

There have been some minor changes to fix typos.

As Andrew said earlier, this patch series (i.e. 01 - 13) has been in -mm
for 2 months without incident.

I've also sent a request for inclusion in future linux-next kernels as
this was missed last time.

There is also a regulator git repository here:-

git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git

Thanks

Liam

