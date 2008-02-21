Return-Path: <linux-kernel-owner+w=401wt.eu-S1758442AbYBUGui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758442AbYBUGui (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 01:50:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753278AbYBUGu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 01:50:26 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50449 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258AbYBUGuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 01:50:25 -0500
Date: Thu, 21 Feb 2008 15:49:16 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: John Stoffel <john@stoffel.org>, Jan Engelhardt <jengelh@computergmbh.de>,
       Andi Kleen <andi@firstfloor.org>, akpm@osdl.org, torvalds@osdl.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] Document huge memory/cache overhead of memory
 controller in Kconfig
Message-Id: <20080221154916.723fed49.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <47BC5211.6030102@linux.vnet.ibm.com>
References: <20080220122338.GA4352@basil.nowhere.org>
	<47BC2275.4060900@linux.vnet.ibm.com>
	<18364.16552.455371.242369@stoffel.org>
	<47BC4554.10304@linux.vnet.ibm.com>
	<Pine.LNX.4.64.0802201647060.26109@fbirervta.pbzchgretzou.qr>
	<18364.20755.798295.881259@stoffel.org>
	<47BC5211.6030102@linux.vnet.ibm.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008 21:45:13 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> > But for computers, limits is an expected and understood term, and for
> > filesystems it's quotas.  So in this case, I *still* think you should
> > be using the term "Memory Quota Controller" instead.  It just makes it
> > clearer to a larger audience what you mean.
> > 
> 
> Memory Quota sounds very confusing to me. Usually a quota implies limits, but in
> a true framework, one can also implement guarantees and shares.
> 
This "cgroup memory contoller" is called as "Memory Resource Contoller"
in my office ;)

How about Memory Resouce Contoller ?


-Kame

