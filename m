Return-Path: <linux-kernel-owner+w=401wt.eu-S1753047AbYLZDVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbYLZDVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 22:21:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbYLZDVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 22:21:44 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54610 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225AbYLZDVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 22:21:44 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH for -tip 0/4] various irq cleanups
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20081226121703.5CA3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Fri, 26 Dec 2008 12:21:39 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

this patch series is irq related cleanups.

I tested on

x86_64 with SPARSE_IRQ
ia64   without !SPARSE_IRQ


I builded on (by cross compiler)

alpha
arm
m68k
m68knommu
s390


total 7 architecutre.



