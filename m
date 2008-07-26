Return-Path: <linux-kernel-owner+w=401wt.eu-S1757230AbYGZTLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230AbYGZTLj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 15:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbYGZTL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 15:11:29 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:39367 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086AbYGZTL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 15:11:28 -0400
Subject: Re: [PATCH] netns: fix ip_rt_frag_needed rt_is_expired
From: "Denis V. Lunev" <den@parallels.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1217090252.6549.4.camel@iris.sw.ru>
References: <Pine.LNX.4.64.0807261345400.6643@blonde.site>
	 <1217090252.6549.4.camel@iris.sw.ru>
Content-Type: text/plain
Organization: Parallels
Date: Sat, 26 Jul 2008 23:10:37 +0400
Message-Id: <1217099437.6549.6.camel@iris.sw.ru>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-07-26 at 20:40 +0400, Denis V. Lunev wrote:
> Acked-by: Denis V. Lunev <den@openvz.org>
> 
> Thanks for founding this issue...

oops... I mean finding and fixing... my fault again

