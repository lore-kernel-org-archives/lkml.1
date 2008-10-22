Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924AbYJVL0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbYJVL0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 07:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbYJVL02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 07:26:28 -0400
Received: from vsmtp04.dti.ne.jp ([202.216.231.139]:59770 "EHLO
	vsmtp04.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbYJVL02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 07:26:28 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: __vm_enough_memory(), OVERCOMMIT_NEVER, current->mm, kernel thread 
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081022092736.2a0795d1@lxorguk.ukuu.org.uk>
References: <7123.1224602071@jrobl> <20081021164619.341f01d9@lxorguk.ukuu.org.uk> <6775.1224630654@jrobl> <20081022092736.2a0795d1@lxorguk.ukuu.org.uk>
Date: Wed, 22 Oct 2008 20:26:19 +0900
Message-ID: <6689.1224674779@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Alan Cox:
> No - the shmem routine would use vm_enough_memory_fs which wouldn't care
> if current->mm is NULL, but the others would check.

Unfortunately I cannot imagine what new vm_enough_memory_fs() will be.
Would you show me its draft or pseudo code?


Junjiro R. Okajima
