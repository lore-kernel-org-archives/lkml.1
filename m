Return-Path: <linux-kernel-owner+w=401wt.eu-S1757098AbYAGMov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098AbYAGMov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 07:44:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754735AbYAGMon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 07:44:43 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:33294 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708AbYAGMom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 07:44:42 -0500
Date: Mon, 7 Jan 2008 07:42:22 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "William L. Irwin" <sparclinux@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 02/11] Add fastcall to do_IRQ for i386
In-Reply-To: <4781AFB1.6040807@zytor.com>
Message-ID: <Pine.LNX.4.58.0801070742070.26038@gandalf.stny.rr.com>
References: <20080103071609.478486470@goodmis.org> <20080103072226.934978594@goodmis.org>
 <20080103173639.GB30582@Krystal> <Pine.LNX.4.58.0801031246220.4826@gandalf.stny.rr.com>
 <4781AFB1.6040807@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 6 Jan 2008, H. Peter Anvin wrote:
>
> I thought we had dropped support for the non-REGPARM case, so why don't
> we just make it work for REGPARM and be done with it?
>

I'm working on that ;-)

-- Steve

