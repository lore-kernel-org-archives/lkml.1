Return-Path: <linux-kernel-owner+w=401wt.eu-S1756480AbXIRCsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480AbXIRCsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 22:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754256AbXIRCsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 22:48:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53214 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754273AbXIRCsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 22:48:07 -0400
Date: Mon, 17 Sep 2007 19:47:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mel@csn.ul.ie" <mel@csn.ul.ie>
Subject: Re: [PATCH] CONFIG_ZONE_MOVABLE [2/2] config zone movable
Message-Id: <20070917194748.a6edb8a5.akpm@linux-foundation.org>
In-Reply-To: <20070831191415.a111636b.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070831191202.50fe90b3.kamezawa.hiroyu@jp.fujitsu.com>
	<20070831191415.a111636b.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Aug 2007 19:14:15 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> Makes ZONE_MOVABLE as configurable
> 
> Based on "zone_ifdef_cleanup_by_renumbering.patch"
> 

This patch causes my old dual-pIII machine to instantly reboot: 0.000001 seconds
uptime.

http://userweb.kernel.org/~akpm/config-vmm.txt
