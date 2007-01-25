Return-Path: <linux-kernel-owner+w=401wt.eu-S1030511AbXAYTFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030511AbXAYTFn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 14:05:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030513AbXAYTFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 14:05:43 -0500
Received: from raven.upol.cz ([158.194.120.4]:34119 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030511AbXAYTFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 14:05:42 -0500
Date: Thu, 25 Jan 2007 19:14:07 +0000
To: Rob Landley <rob@landley.net>
Cc: Andrew Morton <akpm@osdl.org>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: sed _s_gnu_alternatives_ (Re: [rft] (g)awk substitution)
Message-ID: <20070125191407.GA10853@flower.upol.cz>
References: <200701151624.18033.rob@landley.net> <200701242051.34153.rob@landley.net> <20070125094051.GA9725@flower.upol.cz> <200701251303.33607.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200701251303.33607.rob@landley.net>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 25, 2007 at 01:03:32PM -0500, Rob Landley wrote:
> On Thursday 25 January 2007 4:40 am, Oleg Verych wrote:
> > > Your objection is a bit like saying "and don't use cat".  I'm saying don't 
> > > call cat "gcat" when you just mean plain old cat.
> > 
> > No it's not, really. I don't want to see pipes, fork()s, disk seek,
> > when task can be done without it. I know, what awk is, and i hope it
> > will have its better time.
> 
> *shrug*  Making the need for "gawk" go away was my goal, and gawk->awk was the 
> minimal change.  If you want more than that, I'm not objecting, just not 
> personally interested.

Yes making uclibc as a bit more work, than rename things ;D. And my
change is mainly from optimization point of view (say modern embedded ;)

> I believe "shift 5" is also SUSv3. :)

If you have tested, please send ack or nack to us.

Thanks.
____
