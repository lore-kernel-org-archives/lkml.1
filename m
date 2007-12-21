Return-Path: <linux-kernel-owner+w=401wt.eu-S1760838AbXLUAaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760838AbXLUAaa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 19:30:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755077AbXLUAaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 19:30:22 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55441 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244AbXLUAaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 19:30:21 -0500
Date: Fri, 21 Dec 2007 09:30:57 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Hugh Dickins <hugh@veritas.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] [PATCH] Memory controller remove control_type feature
Message-Id: <20071221093057.c2a40c9d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20071220185358.3248.25416.sendpatchset@balbir-laptop>
References: <20071220185358.3248.25416.sendpatchset@balbir-laptop>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Dec 2007 00:23:58 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> 
> 
> Based on the discussion at http://lkml.org/lkml/2007/12/20/383, it was
> felt that control_type might not be a good thing to implement right away.
> We can add this flexibility at a later point when required.
> 
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> ---
> 
I agree with this direction.

Thanks,
-Kame

