Return-Path: <linux-kernel-owner+w=401wt.eu-S1761772AbZLLKmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761772AbZLLKmQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 05:42:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761584AbZLLKmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 05:42:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45127 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761535AbZLLKmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 05:42:14 -0500
Date: Sat, 12 Dec 2009 02:41:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] TTY patches for 2.6.33-git
Message-Id: <20091212024113.45ad2fed.akpm@linux-foundation.org>
In-Reply-To: <20091212101551.GA16049@elte.hu>
References: <20091211232805.GA10652@kroah.com>
	<20091212084611.GA28266@elte.hu>
	<20091212013927.58d386d1.akpm@linux-foundation.org>
	<20091212100656.GA25286@elte.hu>
	<20091212101551.GA16049@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Dec 2009 11:15:51 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> i'm testing the series of 5 reverts below. It's looking good so far. You 
> might want to try them - how quickly can you reproduce the hangs?

Immediately, with http://userweb.kernel.org/~akpm/config-akpm2.txt


