Return-Path: <linux-kernel-owner+w=401wt.eu-S1756821AbYELRWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821AbYELRWQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 13:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753916AbYELRWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 13:22:03 -0400
Received: from laska.dorms.spbu.ru ([195.19.252.72]:38302 "EHLO
	laska.dorms.spbu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765AbYELRWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 13:22:01 -0400
Date: Mon, 12 May 2008 21:21:54 +0400
From: Mikhail Kshevetskiy <kl@laska.dorms.spbu.ru>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: linux-2.6.25: early exception 0e
Message-ID: <20080512212154.788ba5a1@laska>
In-Reply-To: <Pine.LNX.4.64.0805121221480.30585@twin.jikos.cz>
References: <20080510105712.74f17c01@laska>
	<Pine.LNX.4.64.0805121221480.30585@twin.jikos.cz>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2008 12:22:57 +0200 (CEST)
Jiri Kosina <jkosina@suse.cz> wrote:

> On Sat, 10 May 2008, Mikhail Kshevetskiy wrote:
> 
> > I have the following boot problem:
> [ ... ]
> > PANIC: early exception 0e rip 10:ffffffff80224b4e error 0 cr2
> > ffffffffff5fb030
> 
> There should be a stack trace following this message, please post it (we 
> need to know what function does 0xffffffff80224b4e correspond to, at 
> least).

There is nothing more on the screen, just this single line.
I try to enable more kernel debug options, maybe this helps.

Mikhail Kshevetskiy
