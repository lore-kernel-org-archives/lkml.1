Return-Path: <linux-kernel-owner+w=401wt.eu-S1755930AbZKINfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930AbZKINfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 08:35:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755919AbZKINfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 08:35:04 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:32866 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918AbZKINfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 08:35:03 -0500
Date: Mon, 9 Nov 2009 08:34:58 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/3] extend get/setrlimit to support setting rlimits
	external to a process (v7)
Message-ID: <20091109133458.GA19756@hmsreliant.think-freely.org>
References: <20091102175407.GE4075@hmsreliant.think-freely.org> <20091102185137.GA28803@elte.hu> <20091103002355.GB19891@localhost.localdomain> <20091104112632.GA9243@elte.hu> <20091105204843.GA2980@hmsreliant.think-freely.org> <20091106092600.GC22505@elte.hu> <4AF3F3CF.5080503@gmail.com> <20091108103629.GA11372@elte.hu> <20091109001003.GA4129@localhost.localdomain> <4AF7D396.4080304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF7D396.4080304@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Spam-Score: -4.8 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 09, 2009 at 09:32:22AM +0100, Jiri Slaby wrote:
> On 11/09/2009 01:10 AM, Neil Horman wrote:
> > That seems like a reasonable approach to me.  Jiri, would you like to do that or
> > shall I?  I'm happy to but it will take me a few days (I've got a bug I need to
> > focus on first).
> 
> Yup, I'll do that. v7 is the newest version you sent, right?
> 
Correct, thanks!
Neil

