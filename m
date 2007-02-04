Return-Path: <linux-kernel-owner+w=401wt.eu-S1752342AbXBDNwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbXBDNwa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 08:52:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbXBDNwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 08:52:30 -0500
Received: from raven.upol.cz ([158.194.120.4]:41440 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345AbXBDNw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 08:52:29 -0500
Date: Sun, 4 Feb 2007 15:01:18 +0100
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] kbuild: correctly skip tilded backups in localversion files
Message-ID: <20070204140118.GA9188@flower.upol.cz>
References: <20070131071103.GA3295@flower.upol.cz> <20070131155651.529e933c.akpm@osdl.org> <20070201023717.GA22328@flower.upol.cz> <20070131184329.753ce801.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070131184329.753ce801.akpm@osdl.org>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 31, 2007 at 06:43:29PM -0800, Andrew Morton wrote:
> On Thu, 1 Feb 2007 03:37:17 +0100 Oleg Verych <olecom@flower.upol.cz> wrote:
> 
> > On Wed, Jan 31, 2007 at 03:56:51PM -0800, Andrew Morton wrote:
> > > On Wed, 31 Jan 2007 07:11:04 +0000
> > > Oleg Verych <olecom@flower.upol.cz> wrote:
> > > 
> > > > kbuild: correctly skip tilded backups in localversion files
> > > 
> > > Does this patch replace Bastian's patch, below?
> > 
> > Along with "Message-ID: <20070131093542.GA3471@flower.upol.cz>" -- yes.
> > 
> 
> OK.  Just to avoid mistakes, can you please resend everything, against
> 2.6.20-rc7?

I've resent patches, that i wanted to be in -mm, even without anyone,
who can ack or even test them. But it seems, they not made it to lkml.

____
