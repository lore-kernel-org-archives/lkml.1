Return-Path: <linux-kernel-owner+w=401wt.eu-S965656AbXEKT7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965656AbXEKT7n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758868AbXEKT7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:59:36 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33031 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758807AbXEKT7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:59:35 -0400
Date: Fri, 11 May 2007 12:59:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: minyard@acm.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Patrick Schoeller <Patrick.Schoeller@hp.com>
Subject: Re: [PATCH] IPMI: fix SI address space settings
Message-Id: <20070511125929.7000f9d8.akpm@linux-foundation.org>
In-Reply-To: <20070511125616.GA6422@localdomain>
References: <20070511125616.GA6422@localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2007 07:56:16 -0500
Corey Minyard <minyard@acm.org> wrote:

> Fix a rather obvious error that Patrick found in the setup routines.
> Need to set the proper address space in the ACPI case.

I have assumed that both these fixes are desired in 2.6.21.x.

In general, it helps if people can think about that and express an
explicit opinion when sending fixes, please.
