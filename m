Return-Path: <linux-kernel-owner+w=401wt.eu-S1754070AbZBGJH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbZBGJH3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 04:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbZBGJHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 04:07:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50166 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751978AbZBGJG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 04:06:57 -0500
Date: Sat, 7 Feb 2009 01:06:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irq: optimize init_kstat_irqs/init_copy_kstat_irqs
Message-Id: <20090207010619.daededa3.akpm@linux-foundation.org>
In-Reply-To: <86802c440902070101l5b0ef862ja92e3f31705d9608@mail.gmail.com>
References: <498CB0B7.8030009@kernel.org>
	<20090206140005.44b4bb50.akpm@linux-foundation.org>
	<498CB4DC.2010108@kernel.org>
	<498D3D15.5090005@kernel.org>
	<20090207002610.73ff7e6d.akpm@linux-foundation.org>
	<86802c440902070101l5b0ef862ja92e3f31705d9608@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Feb 2009 01:01:03 -0800 Yinghai Lu <yinghai@kernel.org> wrote:

> 
> add kzalloc_node_safe()?

I cannot find that function.


