Return-Path: <linux-kernel-owner+w=401wt.eu-S1754092AbYITXFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbYITXFt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 19:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbYITXFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 19:05:41 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:46408 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbYITXFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 19:05:40 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] add sysctl from printk_tag
Date: Sat, 20 Sep 2008 17:05:36 -0600
User-Agent: KMail/1.9.9
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <1221725137-21947-1-git-send-email-yhlu.kernel@gmail.com> <20080918100621.GA19499@elte.hu>
In-Reply-To: <20080918100621.GA19499@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809201705.37063.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 September 2008 04:06:22 am Ingo Molnar wrote:
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> 
> > under /proc/sys/kernel/printk_tag/ will have acpi, apic, dev, pci
> 
> nice!

Maybe, but it needs an intelligible commit log.  I can read the words,
but they don't make sense.
