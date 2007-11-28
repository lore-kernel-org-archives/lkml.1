Return-Path: <linux-kernel-owner+w=401wt.eu-S1760301AbXK1XXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760301AbXK1XXG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 18:23:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754775AbXK1XWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 18:22:55 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:53377 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754429AbXK1XWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 18:22:54 -0500
Date: Thu, 29 Nov 2007 00:22:45 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Tilman Schmidt <tilman@imap.cc>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: git guidance
Message-ID: <20071129002245.33096661@siona>
In-Reply-To: <Pine.LNX.4.64.0711280019200.4181@fbirervta.pbzchgretzou.qr>
References: <474C9B31.8000408@imap.cc>
	<Pine.LNX.4.64.0711280019200.4181@fbirervta.pbzchgretzou.qr>
Organization: Atmel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2007 00:20:46 +0100 (CET)
Jan Engelhardt <jengelh@computergmbh.de> wrote:

> On Nov 27 2007 23:33, Tilman Schmidt wrote:
> >
> >It didn't work too well. The first result was one of maximal
> >embarrassment: I produced a patch that didn't even compile when
> >applied to the official tree. This shouldn't happen with git, right?
> >Well, it did. So now I'm back to keeping a virgin kernel source tree
> >alongside my development area in order to produce diffs. That can't
> >be right?
> >  
> No, it can't. Use stgit/quilt ;p

No, use "git rebase --interactive" ;-)

I've tried stgit/guilt/quilt as well, but I could never quite get the
hang of it (adding the files _before_ editing is the difficult part.) On
the other hand, git rebase --interactive fit right into my workflow and
improved it massively.

But I guess it's all a matter of personal preference.

Haavard
