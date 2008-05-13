Return-Path: <linux-kernel-owner+w=401wt.eu-S1755655AbYEMJf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655AbYEMJf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 05:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750899AbYEMJfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 05:35:16 -0400
Received: from styx.suse.cz ([82.119.242.94]:59627 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750845AbYEMJfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 05:35:15 -0400
Date: Tue, 13 May 2008 11:35:14 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Mikhail Kshevetskiy <kl@laska.dorms.spbu.ru>
cc: linux-kernel@vger.kernel.org
Subject: Re: linux-2.6.25: early exception 0e
In-Reply-To: <20080512212154.788ba5a1@laska>
Message-ID: <Pine.LNX.4.64.0805131134350.11363@jikos.suse.cz>
References: <20080510105712.74f17c01@laska> <Pine.LNX.4.64.0805121221480.30585@twin.jikos.cz>
 <20080512212154.788ba5a1@laska>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2008, Mikhail Kshevetskiy wrote:

> > > PANIC: early exception 0e rip 10:ffffffff80224b4e error 0 cr2
> > > ffffffffff5fb030
> > There should be a stack trace following this message, please post it (we 
> > need to know what function does 0xffffffff80224b4e correspond to, at 
> > least).
> There is nothing more on the screen, just this single line. I try to 
> enable more kernel debug options, maybe this helps.

Or you could use addr2line utility to at least see what function does 
0xffffffff80224b4e correspond to.

-- 
Jiri Kosina
SUSE Labs
