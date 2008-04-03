Return-Path: <linux-kernel-owner+w=401wt.eu-S1757999AbYDCUmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999AbYDCUmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 16:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbYDCUmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 16:42:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46453 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750928AbYDCUmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 16:42:37 -0400
Date: Thu, 3 Apr 2008 13:41:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: balbir@linux.vnet.ibm.com
Cc: hugh@veritas.com, menage@google.com, kamezawa.hiroyu@jp.fujitsu.com,
       xemul@openvz.org, skumar@linux.vnet.ibm.com, lizf@cn.fujitsu.com,
       rientjes@google.com, yamamoto@valinux.co.jp,
       linux-kernel@vger.kernel.org
Subject: Re: cgroup_disable=memory for 2.6.25?
Message-Id: <20080403134153.d7476dda.akpm@linux-foundation.org>
In-Reply-To: <47F53DA2.3050403@linux.vnet.ibm.com>
References: <Pine.LNX.4.64.0804032055590.8157@blonde.site>
	<47F53DA2.3050403@linux.vnet.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Apr 2008 01:57:14 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> I expected those patches to make it into 2.6.25.

My mind-ray receptors might need a tune-up.

> Could we please push these patches upstream before 2.6.25? Or is it too late?

Should be OK.  I borrowed a bit of Hugh's email and stuck it in the changelog
so that it at least has some attempt to describe why it's an urgent change.
