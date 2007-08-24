Return-Path: <linux-kernel-owner+w=401wt.eu-S1765395AbXHXIs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765395AbXHXIs0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 04:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760211AbXHXIsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 04:48:19 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:39438 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757527AbXHXIsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 04:48:17 -0400
To: balbir@linux.vnet.ibm.com
Cc: akpm@linux-foundation.org, npiggin@suse.de, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, ebiederm@xmission.com, containers@lists.osdl.org,
       menage@google.com, xemul@openvz.org
Subject: Re: [PATCH] Memory controller Add Documentation
In-Reply-To: Your message of "Wed, 22 Aug 2007 18:36:12 +0530"
	<20070822130612.18981.58696.sendpatchset@balbir-laptop>
References: <20070822130612.18981.58696.sendpatchset@balbir-laptop>
X-Mailer: Cue version 0.8 (070404-1613/takashi)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20070824084816.4F23E1BFA1D@siro.lan>
Date: Fri, 24 Aug 2007 17:48:15 +0900 (JST)
From: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +echo 1 > /proc/sys/vm/drop_pages will help get rid of some of the pages
> +cached in the container (page cache pages).

drop_caches

YAMAMOTO Takashi
