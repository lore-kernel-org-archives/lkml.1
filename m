Return-Path: <linux-kernel-owner+w=401wt.eu-S1758142AbYD2G0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142AbYD2G0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 02:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754750AbYD2G0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 02:26:36 -0400
Received: from www.tglx.de ([62.245.132.106]:41522 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbYD2G0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 02:26:35 -0400
Date: Tue, 29 Apr 2008 08:26:27 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: pradeep singh rautela <rautelap@gmail.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [Q]Can a file be dual licensed in upstream kernel?
Message-ID: <20080429062627.GA3195@local>
References: <6bc632150804282237o1aa04e28t93f46874cd14721f@mail.gmail.com> <20080429055356.GA8279@kroah.com> <6bc632150804282310yf2a3bfm5a5e89e5ed4af165@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bc632150804282310yf2a3bfm5a5e89e5ed4af165@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 11:40:26AM +0530, pradeep singh rautela wrote:
> On Tue, Apr 29, 2008 at 11:23 AM, Greg KH <greg@kroah.com> wrote:
> > On Tue, Apr 29, 2008 at 11:07:37AM +0530, pradeep [snip]
> >  > Can a module/file be Dual licensed(i.e BSD/GPLv2) in the upstream
> >  > Linux kernel sources?
> >
> >  Are you somehow not believing the files that we have in the tree that
> >  are licensed this way?
> >  > I think it is GPLv2 only.
> >
> >  Licensing questions would be better off asked to lawyers, not
> >  programmers.  Would you ask a random group of lawyers on a public
> >  mailing list medical questions and trust their responses?
> 
> Um... apologies Greg.I did not mean that in any sense.I am a
> programmer not a lawyer. I am asking to get clear understanding of the
> licensing issues and I myself do not have any good understanding on
> dual licensing Vs GPLv2 licensing in Linux kernel.

I share Greg's opinion that this list is not the place for getting or
giving legal advice. Please _do_ consult a lawyer.
In my _personal_opinion_, dual licensing gives you the right to choose
between two licenses. If a file is dual licensed BSD/GPLv2, anybody
(including yourself) is free to get rid of the BSD part and make it
GPLv2 only.

Thanks,
Hans

