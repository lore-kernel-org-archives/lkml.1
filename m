Return-Path: <linux-kernel-owner+w=401wt.eu-S1752835AbYAIHnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbYAIHnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 02:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbYAIHnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 02:43:11 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56608
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751371AbYAIHnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 02:43:10 -0500
Date: Tue, 08 Jan 2008 23:43:09 -0800 (PST)
Message-Id: <20080108.234309.123460070.davem@davemloft.net>
To: ananth@in.ibm.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       jkenisto@us.ibm.com, mhiramat@redhat.com, hskinnemoen@atmel.com
Subject: Re: [PATCH] Kprobes: Add kprobes smoke tests that run on boot
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080108063334.GA29385@in.ibm.com>
References: <20080108063334.GA29385@in.ibm.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Date: Tue, 8 Jan 2008 12:03:34 +0530

> Here is a quick and naive smoke test for kprobes.

Thanks very much for writing this.

It will come in handy for me when I work on sparc64
kretprobe support.
