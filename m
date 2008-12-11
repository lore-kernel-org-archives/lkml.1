Return-Path: <linux-kernel-owner+w=401wt.eu-S1757244AbYLKQ7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244AbYLKQ7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 11:59:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756408AbYLKQ7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 11:59:32 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43115 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755350AbYLKQ7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 11:59:30 -0500
Date: Thu, 11 Dec 2008 08:59:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: Linux 2.6.28-rc8
Message-Id: <20081211085903.ab14f3f7.akpm@linux-foundation.org>
In-Reply-To: <20081211103800.GC7394@gambetta>
References: <alpine.LFD.2.00.0812101651130.3340@localhost.localdomain>
	<20081211103800.GC7394@gambetta>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Dec 2008 11:38:00 +0100 Frederik Deweerdt <frederik.deweerdt@xprog.eu> wrote:

> On Wed, Dec 10, 2008 at 05:04:39PM -0800, Linus Torvalds wrote:
> > 
> > Nothing overly exciting here. 
> 
> -rc8 could be made even less exciting, it seems, by adding this crutially
> boring fix:
> http://lkml.org/lkml/2008/12/1/345
> 
> It sits in -mm and fixes a regression in mainline (Bugzilla #12047).
> 

I actually have two acpi patches which look like 2.6.28 material.  I shall
resend them to Len.
