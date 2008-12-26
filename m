Return-Path: <linux-kernel-owner+w=401wt.eu-S1753191AbYLZEVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbYLZEVc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 23:21:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbYLZEVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 23:21:22 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57052 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbYLZEVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 23:21:22 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Yinghai Lu" <yinghai@kernel.org>
Subject: Re: [PATCH for -tip 3/4] proc: remove ifdef CONFIG_SPARSE_IRQ from stat.c
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <86802c440812252018w3919614fwaf591aa1e93d2085@mail.gmail.com>
References: <20081226122422.5CAC.KOSAKI.MOTOHIRO@jp.fujitsu.com> <86802c440812252018w3919614fwaf591aa1e93d2085@mail.gmail.com>
Message-Id: <20081226131855.5CB2.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Fri, 26 Dec 2008 13:21:16 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Subject: [PATCH] proc: remove ifdef CONFIG_SPARSE_IRQ from stat.c
> > Impact: cleanup
> >
> > introduce irq_inuse() macro and remove ifdef in stat.c
> 
> should have a good name... irq_inuse is some confusing.

Why?
May I ask your perfered name?


