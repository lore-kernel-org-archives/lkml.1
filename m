Return-Path: <linux-kernel-owner+w=401wt.eu-S1758740AbZLIX04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758740AbZLIX04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 18:26:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758705AbZLIX0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 18:26:52 -0500
Received: from cantor.suse.de ([195.135.220.2]:45460 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758697AbZLIX0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 18:26:51 -0500
Date: Thu, 10 Dec 2009 00:26:57 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Rudy Matela <rudy.matela@gmail.com>
Cc: wharms@bfs.de, Jan Yenya Kasprzak <kas@fi.muni.cz>,
       Krzysztof Halasa <khc@pm.waw.pl>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Coding style correction on some drivers that use Generic
  HDLC
In-Reply-To: <235c15c10912091309q6c20b417y3f80dbac0be2a073@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.0912100025190.3755@pobox.suse.cz>
References: <20091209143540.GA9620@vacuum.larces.uece.br>  <20091209145554.GQ6070@fi.muni.cz> <4B1FC5A4.9030300@bfs.de> <235c15c10912091309q6c20b417y3f80dbac0be2a073@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Dec 2009, Rudy Matela wrote:

> > It is ok until the driver is removed, if this "issue" is not fixed it 
> > will trigger any check-coding-style and generate new patches. Since it 
> > involves no code changes it is harmless.
>   Sould I keep sending coding style corrections to the Linux Kernel?
> I'm trying to help, but if i'm just being annoying, please tell me and
> I can try to contribute in a better way.  :-)

Coding style corrections (if they really improve readability of the code), 
comment fixes (if they really make grepping for things better or make the 
whole text more understandable) are welcome and I will happily merge them.

What I usually don't merge are purely whitespace "fixes", which don't 
really fix anything in fact.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
