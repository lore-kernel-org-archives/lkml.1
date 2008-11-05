Return-Path: <linux-kernel-owner+w=401wt.eu-S1753962AbYKEXMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbYKEXMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 18:12:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbYKEXMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 18:12:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45940 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751568AbYKEXMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 18:12:14 -0500
Date: Wed, 5 Nov 2008 15:12:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: haradats@nttdata.co.jp, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp
Subject: Re: [TOMOYO #12 (2.6.28-rc2-mm1) 03/11] Singly linked list
 implementation.
Message-Id: <20081105151208.6264779c.akpm@linux-foundation.org>
In-Reply-To: <20081104060946.631576722@nttdata.co.jp>
References: <20081104060847.086543472@nttdata.co.jp>
	<20081104060946.631576722@nttdata.co.jp>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch needs a changelog which justifies the addition of the new
infrastructure.

Because an obvious question is "why not just use list_heads?", and this
patch didn't provide the answer to that.  It should do so please.

