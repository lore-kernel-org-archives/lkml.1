Return-Path: <linux-kernel-owner+w=401wt.eu-S1752833AbYEZFku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbYEZFku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 01:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbYEZFkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 01:40:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48581
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750817AbYEZFkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 01:40:40 -0400
Date: Sun, 25 May 2008 22:40:35 -0700 (PDT)
Message-Id: <20080525.224035.202614000.davem@davemloft.net>
To: bunk@kernel.org
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: CONFIG_SPARC64_PAGE_SIZE_4MB build error
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080525185821.GJ1791@cs181133002.pp.htv.fi>
References: <20080525185821.GJ1791@cs181133002.pp.htv.fi>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Sun, 25 May 2008 21:58:21 +0300

> During a compile test I ran into the following build error caused with 
> CONFIG_SPARC64_PAGE_SIZE_4MB:

Thanks for the report, I'll look at this when I get back from my
multi-week trip as this is obviously of a very low priority
to fix :-)
