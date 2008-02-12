Return-Path: <linux-kernel-owner+w=401wt.eu-S1761359AbYBLGoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761359AbYBLGoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 01:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755267AbYBLGoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 01:44:06 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33048
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754613AbYBLGoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 01:44:04 -0500
Date: Mon, 11 Feb 2008 22:44:36 -0800 (PST)
Message-Id: <20080211.224436.174153780.davem@davemloft.net>
To: nickpiggin@yahoo.com.au
Cc: maxk@qualcomm.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, pj@sgi.com, a.p.zijlstra@chello.nl, gregkh@suse.de,
       rusty@rustcorp.com.au
Subject: Re: [git pull for -mm] CPU isolation extensions (updated2)
From: David Miller <davem@davemloft.net>
In-Reply-To: <200802121741.22201.nickpiggin@yahoo.com.au>
References: <47B11C45.6060408@qualcomm.com>
	<200802121741.22201.nickpiggin@yahoo.com.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <nickpiggin@yahoo.com.au>
Date: Tue, 12 Feb 2008 17:41:21 +1100

> stop machine is used for more than just module loading and unloading.
> I don't think you can just disable it.

Right, in particular it is used for CPU hotplug.
