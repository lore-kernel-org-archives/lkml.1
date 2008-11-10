Return-Path: <linux-kernel-owner+w=401wt.eu-S1754486AbYKJPvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbYKJPvh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 10:51:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbYKJPv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 10:51:29 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:36290 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbYKJPv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 10:51:28 -0500
Subject: Re: [BUGFIX][PATCH] memcg: memory hotplug fix
From: Badari Pulavarty <pbadari@us.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
In-Reply-To: <20081110183839.e551a52e.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081110183839.e551a52e.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain
Date: Mon, 10 Nov 2008 07:52:35 -0800
Message-Id: <1226332355.8805.6.camel@badari-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-10 at 18:38 +0900, KAMEZAWA Hiroyuki wrote:
> This is a bug fix reported against 2.6.28-rc3 from Badari.
> Badari, could you give me Ack or Tested-by ?
> 
> Thanks,
> -Kame
> ==
> start pfn calculation of page_cgroup's memory hotplug notifier chain
> is wrong.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Tested-by: Badari Pulavarty <pbadari@us.ibm.com>

