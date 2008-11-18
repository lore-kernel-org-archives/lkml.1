Return-Path: <linux-kernel-owner+w=401wt.eu-S1753471AbYKRX2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbYKRX2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 18:28:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbYKRX2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 18:28:40 -0500
Received: from www.church-of-our-saviour.org ([69.25.196.31]:33798 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751737AbYKRX2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 18:28:39 -0500
Date: Tue, 18 Nov 2008 18:28:31 -0500
From: Theodore Tso <tytso@mit.edu>
To: Fredrik =?iso-8859-1?Q?Markstr=F6m?= 
	<fredrik.markstrom@avalonenterprise.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Valdis.Kletnieks@vt.edu,
       linux-kernel@vger.kernel.org
Subject: Re: Developing non-commercial drivers ?
Message-ID: <20081118232831.GA7863@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Fredrik =?iso-8859-1?Q?Markstr=F6m?= <fredrik.markstrom@avalonenterprise.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Valdis.Kletnieks@vt.edu,
	linux-kernel@vger.kernel.org
References: <fc262dee0811180816k29cc93aas51c2c47ede2c7a1@mail.gmail.com> <63125.1227036333@turing-police.cc.vt.edu> <20081118192942.3c676f0d@lxorguk.ukuu.org.uk> <20081118202057.GF29975@mit.edu> <fc262dee0811181313n35f39184ne438ddebb0225ba5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fc262dee0811181313n35f39184ne438ddebb0225ba5@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2008 at 10:13:30PM +0100, Fredrik Markström wrote:
> 
> Unfortunately I can't disclose our client simply because I have not
> asked for their permission.

Understood, of course not.  All you can do is suggest that they might
want to contact us.

> Anyway strongly doubt they want to do something illegal or wrong, but
> a lot of people obviously thinks binary drivers are accepted by the
> Linux community and licensing. It sure would be nice if this could be
> stated more explicit in some official FAQ.

There are many different ways to use the word "wrong".  There is
"morally wrong" (as in, goes against the spirit of the license and of
the development community).  There is "legally wrong", which depends
on the legal jurisdiction (of you, the company, and the end user),
which will require a lawyer's input.  And then there's "pragamatically
wrong", as in, regardless of whether it's legal, there are significant
technical downsides in trying to trying to develop binary-only drivers
that in the long run will cost you money.

> Your (the Linux Foundations) web gives the impression that you protect
> Linux against external interests (like my clients),  but do you have
> to authority to work the other way ? Can you make deals or promises on
> behalf of the copyright owners of the Linux kernel ? I doubt that but
> might be wrong.

No, of course not.  That being said, there are binary modules out
there, and there are ways which are "safer" in terms of whether you
are likely to get sued, if the company you are working with wants to
skate close to the dark side and live in the same legal grey zone as
Nvidia and Broadcom.

> Anyway, I'm not sure how the Linux Foundation can help in this case,
> if you can explain that, I sure will bring it up with our client.

We can give advice; but it's well informed advice.

						- Ted
