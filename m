Return-Path: <linux-kernel-owner+w=401wt.eu-S1760042AbXIJNlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760042AbXIJNlL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 09:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757616AbXIJNkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 09:40:55 -0400
Received: from atlrel9.hp.com ([156.153.255.214]:55948 "EHLO atlrel9.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757185AbXIJNky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 09:40:54 -0400
Message-ID: <46E54945.30806@hp.com>
Date: Mon, 10 Sep 2007 09:40:21 -0400
From: Vlad Yasevich <vladislav.yasevich@hp.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
Cc: Wei Yongjun <yjwei@cn.fujitsu.com>, sri@us.ibm.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org, lksctp-developers@lists.sourceforge.net,
       netdev@vger.kernel.org
Subject: Re: [2.6 patch] make sctp_addto_param() static
References: <20070909202550.GX3563@stusta.de>
In-Reply-To: <20070909202550.GX3563@stusta.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> sctp_addto_param() can become static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Ack

-vlad
