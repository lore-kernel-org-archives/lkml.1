Return-Path: <linux-kernel-owner+w=401wt.eu-S1762854AbXESMTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762854AbXESMTL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 08:19:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758209AbXESMS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 08:18:59 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34860 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758069AbXESMS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 08:18:58 -0400
Date: Sat, 19 May 2007 14:18:55 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Jens Axboe <jens.axboe@oracle.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Steven Pratt <slpratt@austin.ibm.com>,
       Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH 9/9] readahead: remove the old algorithm
Message-ID: <20070519121855.GC25563@one.firstfloor.org>
References: <20070516224752.500812933@mail.ustc.edu.cn> <20070516224819.420933490@mail.ustc.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070516224819.420933490@mail.ustc.edu.cn>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 06:48:01AM +0800, Fengguang Wu wrote:
> Remove the old readahead algorithm.

FWIW - i read the complete patchkit. While I'm not a particular expert
on that code i didn't see anything I didn't like

-Andi
