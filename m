Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201AbYJWV7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbYJWV7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 17:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbYJWV7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 17:59:37 -0400
Received: from ftp.linux-mips.org ([213.58.128.207]:38438 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbYJWV7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 17:59:37 -0400
Date: Thu, 23 Oct 2008 22:59:30 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Aristeu Rozanski <aris@ruivo.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] nmi watchdog: handle NMI_IO_APIC on nmi_watchdog
In-Reply-To: <20081023033540.GF28317@cathedrallabs.org>
Message-ID: <alpine.LFD.1.10.0810232256510.3152@ftp.linux-mips.org>
References: <20080313180538.GC4620@cathedrallabs.org> <20080321114752.GA25225@elte.hu> <20080326152417.GE25854@cathedrallabs.org> <20080326182333.GA11187@elte.hu> <20081022215008.GE28317@cathedrallabs.org> <alpine.LFD.1.10.0810222329410.24509@ftp.linux-mips.org>
 <20081023033540.GF28317@cathedrallabs.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008, Aristeu Rozanski wrote:

> >  You seem to be writing in reply to a very old thread -- please make sure 
> > your concerns are still valid with current code.  For example we have an 
> > implementation of __acpi_nmi_disable() now, which is exactly your proposed 
> > one.
> didn't noticed that, sorry.

 Well, as it is, it looks the rest of your patch may still be useful -- I 
haven't investigated it any further, so if still interested, please do 
have a look into it.

  Maciej
