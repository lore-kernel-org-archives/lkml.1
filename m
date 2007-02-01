Return-Path: <linux-kernel-owner+w=401wt.eu-S1161280AbXBACnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161280AbXBACnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 21:43:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933354AbXBACnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 21:43:45 -0500
Received: from smtp.osdl.org ([65.172.181.24]:38389 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933352AbXBACno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 21:43:44 -0500
Date: Wed, 31 Jan 2007 18:43:29 -0800
From: Andrew Morton <akpm@osdl.org>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, Roman Zippel <zippel@linux-m68k.org>,
       Bastian Blank <bastian@waldi.eu.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch] kbuild: correctly skip tilded backups in localversion
 files
Message-Id: <20070131184329.753ce801.akpm@osdl.org>
In-Reply-To: <20070201023717.GA22328@flower.upol.cz>
References: <20070131071103.GA3295@flower.upol.cz>
	<20070131155651.529e933c.akpm@osdl.org>
	<20070201023717.GA22328@flower.upol.cz>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Feb 2007 03:37:17 +0100 Oleg Verych <olecom@flower.upol.cz> wrote:

> On Wed, Jan 31, 2007 at 03:56:51PM -0800, Andrew Morton wrote:
> > On Wed, 31 Jan 2007 07:11:04 +0000
> > Oleg Verych <olecom@flower.upol.cz> wrote:
> > 
> > > kbuild: correctly skip tilded backups in localversion files
> > 
> > Does this patch replace Bastian's patch, below?
> 
> Along with "Message-ID: <20070131093542.GA3471@flower.upol.cz>" -- yes.
> 

OK.  Just to avoid mistakes, can you please resend everything, against
2.6.20-rc7?
