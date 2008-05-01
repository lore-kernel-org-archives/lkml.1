Return-Path: <linux-kernel-owner+w=401wt.eu-S933303AbYEBJdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933303AbYEBJdu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 05:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759403AbYEBJdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 05:33:40 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51353 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbYEBJdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 05:33:39 -0400
Date: Thu, 1 May 2008 04:33:13 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: linux-next: WARNING: at kernel/panic.c:375
 __stack_chk_test+0x50/0x54()
Message-ID: <20080501043313.02205bbd@linux.intel.com>
In-Reply-To: <481A4636.8050209@gmail.com>
References: <4819078C.9080405@gmail.com>
	<48190844.5080804@linux.intel.com>
	<48190DBB.9020102@gmail.com>
	<20080430002727.00db8e63@linux.intel.com>
	<481A4636.8050209@gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

\
> Does that help?

somewhat. If you still have your source tree, can you do

make kernel/panic.s and send that file to me as well?
(offlist is fine)

Greetings,
   Arjan van de Ven

> 
