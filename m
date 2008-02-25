Return-Path: <linux-kernel-owner+w=401wt.eu-S1757936AbYBYTt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936AbYBYTt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 14:49:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755828AbYBYTtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 14:49:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55843 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755826AbYBYTtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 14:49:50 -0500
Date: Mon, 25 Feb 2008 14:48:35 -0500
From: Alan Cox <alan@redhat.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Steven Rostedt <srostedt@redhat.com>,
       Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@redhat.com>
Subject: Re: [PATCH] 2.6.25-rc2-mm1 - fix mcount GPL bogosity.
Message-ID: <20080225194835.GA28042@devserv.devel.redhat.com>
References: <30804.1203962369@turing-police.cc.vt.edu> <47C3078E.3000008@redhat.com> <20080225181957.4eeed15d@core> <20080225192710.GA13635@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080225192710.GA13635@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 09:27:10PM +0200, Adrian Bunk wrote:
> > As I understand it if Vladis wants to submit his own change to the symbol
> > thats up to him, and he'll be liable for any fallout with the FSF, or
> > harm to Linux resulting, so long he's the one who signs it off.
> 
> Why isn't anyone distributing it liable if it is not legally correct?

They may well be, but they all get to sue Vladis in turn

Alan

