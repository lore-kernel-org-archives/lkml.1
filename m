Return-Path: <linux-kernel-owner+w=401wt.eu-S1759441AbXJXU14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759441AbXJXU14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 16:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755541AbXJXU1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 16:27:46 -0400
Received: from atlrel9.hp.com ([156.153.255.214]:46934 "EHLO atlrel9.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754051AbXJXU1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 16:27:45 -0400
Message-ID: <471FAABA.4080006@hp.com>
Date: Wed, 24 Oct 2007 16:27:38 -0400
From: Vlad Yasevich <vladislav.yasevich@hp.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
Cc: sri@us.ibm.com, lksctp-developers@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [2.6 patch] net/sctp/auth.c: make 3 functions static
References: <20071024162428.GJ30533@stusta.de>
In-Reply-To: <20071024162428.GJ30533@stusta.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch makes three needlessly global functions static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

ACK.  Thanks for catching these..

-vlad
