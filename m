Return-Path: <linux-kernel-owner+w=401wt.eu-S1754581AbXG3EAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbXG3EAT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 00:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750803AbXG3EAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 00:00:04 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:51317 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750906AbXG3EAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 00:00:02 -0400
To: menage@google.com
Cc: akpm@linux-foundation.org, dev@sw.ru, xemul@sw.ru, serue@us.ibm.com,
       vatsa@in.ibm.com, ebiederm@xmission.com, haveblue@us.ibm.com,
       svaidy@linux.vnet.ibm.com, balbir@in.ibm.com, pj@sgi.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, rohitseth@google.com
Subject: Re: [PATCH 01/10] Task Containers(V11): Basic task container
 framework
In-Reply-To: Your message of "Fri, 20 Jul 2007 11:31:53 -0700"
	<20070720191247.388947000@menage.corp.google.com>
References: <20070720191247.388947000@menage.corp.google.com>
X-Mailer: Cue version 0.8 (070404-1613/takashi)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20070730040000.5EF111BF6B4@siro.lan>
Date: Mon, 30 Jul 2007 13:00:00 +0900 (JST)
From: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +extern void container_init_smp(void);

> +static inline void container_init_smp(void) {}

stale prototypes?

YAMAMOTO Takashi
