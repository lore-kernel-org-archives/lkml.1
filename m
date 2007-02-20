Return-Path: <linux-kernel-owner+w=401wt.eu-S965013AbXBTP1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965013AbXBTP1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 10:27:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965036AbXBTP1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 10:27:12 -0500
Received: from smtp.nokia.com ([131.228.20.173]:51102 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965013AbXBTP1L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 10:27:11 -0500
Subject: Re: [PATCH 05/44 take 2] [UBI] internal common header
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Theodore Tso <tytso@mit.edu>
Cc: Christoph Hellwig <hch@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20070220145503.GC3170@thunk.org>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
	 <20070217165449.5845.18238.sendpatchset@localhost.localdomain>
	 <20070219105445.GA16930@infradead.org> <1171976753.4039.27.camel@sauron>
	 <20070220145503.GC3170@thunk.org>
Content-Type: text/plain; charset=utf-8
Date: Tue, 20 Feb 2007 17:25:58 +0200
Message-Id: <1171985158.4039.46.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 20 Feb 2007 15:25:58.0436 (UTC) FILETIME=[6BC00E40:01C75503]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070220172229-04337BB0-6C9EB8FC/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-20 at 09:55 -0500, Theodore Tso wrote:
> BTW, it might also be a good idea to run UBI through sparse to catch bugs.

Ran it before, will do before the next submission iteration.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

