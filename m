Return-Path: <linux-kernel-owner+w=401wt.eu-S1752368AbXA0UGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbXA0UGJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 15:06:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbXA0UGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 15:06:09 -0500
Received: from smtp.osdl.org ([65.172.181.24]:33381 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368AbXA0UGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 15:06:08 -0500
Date: Sat, 27 Jan 2007 12:05:12 -0800
From: Andrew Morton <akpm@osdl.org>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Ingo@maccavity.nachtwache.org, Christoph@maccavity.nachtwache.org,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       "Martin J. Bligh" <mbligh@mbligh.org>, Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@osdl.org>, Molnar <mingo@redhat.com>,
       ltt-dev@shafik.org, systemtap@sources.redhat.com,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Douglas Niehaus <niehaus@eecs.ku.edu>
Subject: Re: [Ltt-dev] [PATCH 00/09] atomic.h : standardizing atomic
 primitives
Message-Id: <20070127120512.04a98fcd.akpm@osdl.org>
In-Reply-To: <20070127181116.GA5158@Krystal>
References: <11697417541743-git-send-email-mathieu.desnoyers@polymtl.ca>
	<20070127021834.e26e955d.akpm@osdl.org>
	<20070127181116.GA5158@Krystal>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Jan 2007 13:11:16 -0500
Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:

> I am currently trying crosstool by Dan Kegel, it looks promising.
> http://www.kegel.com/crosstool/

Yeah, I spent a frustrating two days with crosstool, managed to eke a
number of cross-compilers out of it, but it took a *lot* of experimentation
with gcc, glibc and binutils versions to get combinations which actually
work.  Good luck ;)

There used to be someone who had a full suite, and who regularly published
cross-compile results, but he stopped 6-12 months ago and I forget who that
clever person was?

