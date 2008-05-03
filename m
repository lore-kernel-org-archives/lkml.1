Return-Path: <linux-kernel-owner+w=401wt.eu-S1750993AbYECPbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750993AbYECPbb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 11:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757669AbYECPbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 11:31:23 -0400
Received: from mxl.seznam.cz ([77.75.72.44]:39642 "EHLO mxl.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757306AbYECPbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 11:31:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=beta; d=seznam.cz;
	h=To:Date:From:Received:Subject:Mime-Version:Message-Id:Content-Transfer-Encoding:Content-Type:X-Abuse:X-Seznam-User:X-QM-Mark;
	b=IyrvVoc/cDA6QiHUpmqGlRSv8ErSrJZDYZ5ni18cIx1LDBxYqxLYslMDPVGrKaehx
	lo8VdsAR8RabaWvWBuAgj0EvbbI26pRcQKWqG80f1Bi9HIpWL39w5oYknPyxMR+RbVP
	WafQoioc1kU9bp8g7F0Ik1tTjvfWgOIgtjQ24Pc=
To: =?us-ascii?Q?Arnd=20Bergmann?= <arnd@arndb.de>,
       =?us-ascii?Q?John=20Williams?= <john.williams@petalogix.com>,
       =?us-ascii?Q?Matthew=20Wilcox?= <matthew@wil.cx>,
       =?us-ascii?Q?Will=20Newton?= <will.newton@gmail.com>,
       =?us-ascii?Q?Linux=20Kernel=20list?= <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, git@xilinx.com,
       =?us-ascii?Q?Stephen=20Neuendorffer?= 
	<stephen.neuendorffer@xilinx.com>,
       =?us-ascii?Q?John=20Linn?= <John.Linn@xilinx.com>,
       =?us-ascii?Q?Ulrich=20Drepper?= <drepper@redhat.com>, paulus@samba.org
Date: Sat, 03 May 2008 17:30:41 +0200 (CEST)
From: =?us-ascii?Q?Michal=20Simek?= <Monstr@seznam.cz>
Subject: =?us-ascii?Q?OF=20files?=
Mime-Version: 1.0
Message-Id: <5257.8247-18740-1017760922-1209828638@seznam.cz>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset="us-ascii"
X-Abuse: abuse@seznam.cz
X-Seznam-User: Monstr@seznam.cz
X-QM-Mark: email-qm2<49140063>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paulus and others,

I tested OF files changes. I sent you some patches about.

I look at headers files too. Is it possible to move prom.h, of_device.h and of_platform.h to asm-generic or linux folder? 

Thanks,
Michal Simek
