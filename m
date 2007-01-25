Return-Path: <linux-kernel-owner+w=401wt.eu-S965395AbXAYSDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965395AbXAYSDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 13:03:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965387AbXAYSDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 13:03:52 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:52015
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965395AbXAYSDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 13:03:52 -0500
From: Rob Landley <rob@landley.net>
To: Oleg Verych <olecom@flower.upol.cz>
Subject: Re: sed _s_gnu_alternatives_ (Re: [rft] (g)awk substitution)
Date: Thu, 25 Jan 2007 13:03:32 -0500
User-Agent: KMail/1.9.1
Cc: Andrew Morton <akpm@osdl.org>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200701151624.18033.rob@landley.net> <200701242051.34153.rob@landley.net> <20070125094051.GA9725@flower.upol.cz>
In-Reply-To: <20070125094051.GA9725@flower.upol.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701251303.33607.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 January 2007 4:40 am, Oleg Verych wrote:
> > Your objection is a bit like saying "and don't use cat".  I'm saying don't 
> > call cat "gcat" when you just mean plain old cat.
> 
> No it's not, really. I don't want to see pipes, fork()s, disk seek,
> when task can be done without it. I know, what awk is, and i hope it
> will have its better time.

*shrug*  Making the need for "gawk" go away was my goal, and gawk->awk was the 
minimal change.  If you want more than that, I'm not objecting, just not 
personally interested.

I believe "shift 5" is also SUSv3. :)

Rob
-- 
"Perfection is reached, not when there is no longer anything to add, but
when there is no longer anything to take away." - Antoine de Saint-Exupery
