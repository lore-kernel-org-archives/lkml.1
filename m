Return-Path: <linux-kernel-owner+w=401wt.eu-S1757337AbYGZT1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337AbYGZT1Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 15:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbYGZT1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 15:27:16 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:45840 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbYGZT1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 15:27:15 -0400
Date: Sat, 26 Jul 2008 20:26:39 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: "Denis V. Lunev" <den@parallels.com>
cc: David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netns: fix ip_rt_frag_needed rt_is_expired
In-Reply-To: <1217099437.6549.6.camel@iris.sw.ru>
Message-ID: <Pine.LNX.4.64.0807262025010.10215@blonde.site>
References: <Pine.LNX.4.64.0807261345400.6643@blonde.site> 
 <1217090252.6549.4.camel@iris.sw.ru> <1217099437.6549.6.camel@iris.sw.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jul 2008, Denis V. Lunev wrote:
> On Sat, 2008-07-26 at 20:40 +0400, Denis V. Lunev wrote:
> > Acked-by: Denis V. Lunev <den@openvz.org>
> > 
> > Thanks for founding this issue...
> 
> oops... I mean finding and fixing... my fault again

No problem - and both errors were quite understandable!

Hugh
