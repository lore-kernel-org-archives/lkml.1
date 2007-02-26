Return-Path: <linux-kernel-owner+w=401wt.eu-S1751314AbXBZLzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314AbXBZLzg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 06:55:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbXBZLzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 06:55:36 -0500
Received: from smtp.nokia.com ([131.228.20.170]:21087 "EHLO
	mgw-ext11.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbXBZLzf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 06:55:35 -0500
Subject: Re: [PATCH 06/44 take 2] [UBI] startup code
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>, rusty@rustcorp.com.au
In-Reply-To: <20070225055828.GC9137@infradead.org>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
	 <20070217165454.5845.30875.sendpatchset@localhost.localdomain>
	 <20070219105927.GB16930@infradead.org> <1171976456.4039.21.camel@sauron>
	 <20070225055828.GC9137@infradead.org>
Content-Type: text/plain; charset=utf-8
Date: Mon, 26 Feb 2007 13:54:24 +0200
Message-Id: <1172490864.4039.103.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 26 Feb 2007 11:54:24.0475 (UTC) FILETIME=[DC09D2B0:01C7599C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-02-25 at 05:58 +0000, Christoph Hellwig wrote:
> because this type of compount interface is really painful for the user.
> the module.param=foo syntax makes sure paramaters can be used without
> endless documentation for each and every single of them, and makes
> sure module writers don't introduce bugs in their own parser reimplementations.

I stand that without the use this function the interface is much worse.
I will be grateful if you advice something better.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

