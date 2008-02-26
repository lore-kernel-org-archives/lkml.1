Return-Path: <linux-kernel-owner+w=401wt.eu-S1758973AbYBZBWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758973AbYBZBWi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 20:22:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbYBZBW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 20:22:27 -0500
Received: from sinclair.provo.novell.com ([137.65.248.137]:18676 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbYBZBW0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 20:22:26 -0500
Message-Id: <47C321E9.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Mon, 25 Feb 2008 18:15:37 -0700
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Sven Dietrich" <SDietrich@novell.com>, "Pavel Machek" <pavel@ucw.cz>
Cc: <a.p.zijlstra@chello.nl>, <mingo@elte.hu>, <bill.huey@gmail.com>,
       <rostedt@goodmis.org>, <kevin@hilman.org>, <tglx@linutronix.de>,
       <cminyard@mvista.com>, <dsingleton@mvista.com>, <dwalker@mvista.com>,
       "Moiz Kohari" <MKohari@novell.com>,
       "Peter Morreale" <PMorreale@novell.com>, <dsaxena@plexity.net>,
       <acme@redhat.com>, <ak@suse.de>, <gregkh@suse.de>, <npiggin@suse.de>,
       <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>
Subject: Re: [(RT RFC) PATCH v2 2/9] sysctl for runtime-control of
	lateral mutex stealing
References: <20080225155959.11268.35541.stgit@novell1.haskins.net>
 <20080225160048.11268.55059.stgit@novell1.haskins.net>
 <20080225215335.GE2659@elf.ucw.cz>
 <1203980231.16711.115.camel@sven.thebigcorporation.com>
In-Reply-To: <1203980231.16711.115.camel@sven.thebigcorporation.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Mon, Feb 25, 2008 at  5:57 PM, in message
<1203980231.16711.115.camel@sven.thebigcorporation.com>, Sven-Thorsten Dietrich
<sdietrich@novell.com> wrote: 
>
> But Greg may need to enforce it on his git tree that he mails these from
> - are you referring to anything specific in this patch?
> 

Thats what I don't get.  I *did* checkpatch all of these before sending them out (and I have for every release).

I am aware of two "tabs vs spaces" warnings, but the rest checked clean.  Why do some people still see errors when I don't?  Is there a set of switches I should supply to checkpatch to make it more aggressive or something?

-Greg

