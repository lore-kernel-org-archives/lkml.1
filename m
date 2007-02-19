Return-Path: <linux-kernel-owner+w=401wt.eu-S932298AbXBSOjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298AbXBSOjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 09:39:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932309AbXBSOjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 09:39:52 -0500
Received: from smtp.nokia.com ([131.228.20.171]:59383 "EHLO
	mgw-ext12.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932298AbXBSOjt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 09:39:49 -0500
Subject: Re: [PATCH 22/44 take 2] [UBI] background thread unit
	implementation
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
In-Reply-To: <20070219110930.GF16930@infradead.org>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
	 <20070217165615.5845.79171.sendpatchset@localhost.localdomain>
	 <20070219110930.GF16930@infradead.org>
Content-Type: text/plain; charset=utf-8
Date: Mon, 19 Feb 2007 15:55:11 +0200
Message-Id: <1171893311.13817.74.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 19 Feb 2007 13:56:29.0494 (UTC) FILETIME=[C132C560:01C7542D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-19 at 11:09 +0000, Christoph Hellwig wrote:
> This really should use the linux/kthread.h infrastructure, and most of the
> code in here would simply go away.

I will look at the infrastructure, thanks.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

