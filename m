Return-Path: <linux-kernel-owner+w=401wt.eu-S1763454AbYBZRc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763454AbYBZRc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 12:32:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760926AbYBZRcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 12:32:20 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:50000 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759259AbYBZRcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 12:32:19 -0500
Date: Tue, 26 Feb 2008 09:29:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Anton Blanchard <anton@samba.org>, Soeren Sandmann <sandmann@daimi.au.dk>,
       John Levon <levon@movementarian.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       tglx@tglx.de, hpa@zytor.com
Subject: Re: [PATCH] x86: add the debugfs interface for the sysprof tool
Message-Id: <20080226092926.3a72f73b.akpm@linux-foundation.org>
In-Reply-To: <20080226090223.GG9857@elte.hu>
References: <20080219123756.6261c13c@laptopd505.fenrus.org>
	<20080223001130.d8922136.akpm@linux-foundation.org>
	<20080223113724.GB31304@elte.hu>
	<20080223135335.GA28464@totally.trollied.org.uk>
	<ye8ejb3e8ef.fsf@camel10.daimi.au.dk>
	<20080226051307.GC17772@kryten>
	<20080226090223.GG9857@elte.hu>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008 10:02:23 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> > Anton - who has used oprofile to analyse and tune databases, JVMs,
> > 	compilers and operating systems. Maybe I've been missing out on
> > 	the killer app for all this time!!!
> 
> it's OK if you use it full time and if you are amongst the 0.001% of the 
> developer population we call "the best kernel hackers on the planet" ;-) 
> 
> It sucks badly if you use it occasionally and have to re-learn its 
> non-trivial usage and its quirks every time. As it happens, most 
> userspace developers are in this second category.

Nobody has in any way demonstrated that this is due to the design or
implementation of oprofile's kernel component.
