Return-Path: <linux-kernel-owner+w=401wt.eu-S1758054AbZFWJU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054AbZFWJU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 05:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755635AbZFWJUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 05:20:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54532 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755446AbZFWJUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 05:20:07 -0400
Date: Tue, 23 Jun 2009 11:20:09 +0200 (CEST)
From: Jiri Kosina <trivial@kernel.org>
X-X-Sender: jkosina@wotan.suse.de
To: Pavel Machek <pavel@ucw.cz>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trivial: cleanup hpfall example code (checkpatch)
In-Reply-To: <20090622172113.GC21149@elf.ucw.cz>
Message-ID: <alpine.LNX.2.00.0906231119550.7457@wotan.suse.de>
References: <200906221108.37471.elendil@planet.nl> <20090622172113.GC21149@elf.ucw.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jun 2009, Pavel Machek wrote:

> On Mon 2009-06-22 11:08:36, Frans Pop wrote:
> > This patch makes hpfall.c conform to kernel coding style.
> > 
> > I have not fixed the C99 // comments on two lines as they
> > help indicate that those are not actually comments but
> > incomplete code.
> > 
> > Before:
> >  total: 10 errors, 6 warnings, 101 lines checked
> > After:
> >  total: 2 errors, 0 warnings, 99 lines checked
> > 
> > Signed-off-by: Frans Pop <elendil@planet.nl>
> 
> Acked-by: Pavel Machek <pavel@ucw.cz>

Applied, thanks Frans.

-- 
Jiri Kosina
SUSE Labs

