Return-Path: <linux-kernel-owner+w=401wt.eu-S932912AbXAWIpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932912AbXAWIpM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 03:45:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932917AbXAWIpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 03:45:12 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3633 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932912AbXAWIpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 03:45:11 -0500
Date: Tue, 23 Jan 2007 08:44:28 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Samium Gromoff <_deepfire@feelingofgreen.ru>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       David Wagner <daw@cs.berkeley.edu>
Subject: Re: [PATCH] Undo some of the pseudo-security madness
Message-ID: <20070123084427.GA5560@ucw.cz>
References: <87y7nxvk65.wl@betelheise.deep.net> <1169345764.3055.935.camel@laptopd505.fenrus.org> <87tzykuj49.wl@betelheise.deep.net> <1169426146.3055.1163.camel@laptopd505.fenrus.org> <87sle3x82o.wl@betelheise.deep.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sle3x82o.wl@betelheise.deep.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > nor will they work if the sysadmin applies a security update and glibc
> > or another library changes one page in size. Or changes the stack rlimit
> > or .. or ..
> 
> Now, i figured out, there is a certain reasonable safety gap which works
> for people, because the libraries depended on are well known.
> 
> What happens with AS randomisation, is that the variance is simply too
> large. But what is more important, is that vendors do modifications
> which change the amount of randomisation, which means that potentially

Complain to vendors, not here.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
