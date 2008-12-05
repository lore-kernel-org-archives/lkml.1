Return-Path: <linux-kernel-owner+w=401wt.eu-S1756809AbYLEWvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809AbYLEWvY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 17:51:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751138AbYLEWvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 17:51:15 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:58153 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbYLEWvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 17:51:14 -0500
Date: Fri, 5 Dec 2008 22:51:07 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Matt Mackall <mpm@selenic.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] shmem: unify regular and tiny shmem
In-Reply-To: <1228517033.3255.241.camel@calx>
Message-ID: <Pine.LNX.4.64.0812052249240.30597@blonde.anvils>
References: <1228425564.3255.121.camel@calx>  <Pine.LNX.4.64.0812051311530.10157@blonde.anvils>
  <1228500936.3255.210.camel@calx>  <Pine.LNX.4.64.0812052218120.27321@blonde.anvils>
 <1228517033.3255.241.camel@calx>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Dec 2008, Matt Mackall wrote:
> 
> Ok, here's a version with the rm of tiny-shmem restored. Andrew, please
> apply.

Acked-by: Hugh Dickins <hugh@veritas.com>
