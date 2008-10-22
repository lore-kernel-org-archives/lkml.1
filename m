Return-Path: <linux-kernel-owner+w=401wt.eu-S1752357AbYJVFfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbYJVFfg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 01:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbYJVFf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 01:35:27 -0400
Received: from vsmtp01.dti.ne.jp ([202.216.231.136]:56130 "EHLO
	vsmtp01.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbYJVFf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 01:35:27 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: __vm_enough_memory(), OVERCOMMIT_NEVER, current->mm, kernel thread 
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <6775.1224630654@jrobl>
References: <7123.1224602071@jrobl> <20081021164619.341f01d9@lxorguk.ukuu.org.uk> <6775.1224630654@jrobl>
Date: Wed, 22 Oct 2008 14:35:16 +0900
Message-ID: <6715.1224653716@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I guess
> - people don't care overcommit and leave it as default, so they don't
>   meet the problem 
> - people who cares overcommit has rich memory, and they don't meet the
>   problem too.

Correction: the problem is unrelated to the memory size.
I was sleepy when I wrote that.
Regardless the memory size, when nfsd writes to tmpfs the system surely
crashes.


Junjiro R. Okajima
