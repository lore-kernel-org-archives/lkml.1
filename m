Return-Path: <linux-kernel-owner+w=401wt.eu-S1753979AbYKJGt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbYKJGt2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 01:49:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbYKJGtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 01:49:19 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48881 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbYKJGtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 01:49:19 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [patch] oom: fix zone_scan_mutex name
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0810280259140.15270@chino.kir.corp.google.com>
References: <alpine.DEB.1.10.0810280259140.15270@chino.kir.corp.google.com>
Message-Id: <20081110154842.616B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Mon, 10 Nov 2008 15:49:15 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> zone_scan_mutex is actually a spinlock, so name it appropriately.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>

looks good to me.

	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



