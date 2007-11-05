Return-Path: <linux-kernel-owner+w=401wt.eu-S1756605AbXKESwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbXKESwV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 13:52:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbXKESwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 13:52:04 -0500
Received: from web50101.mail.re2.yahoo.com ([206.190.38.29]:21643 "HELO
	web50101.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751087AbXKESwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 13:52:03 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=JCb81Pgjuw24lXWEJQNGOc7fLYlYLj/9WTnaRCjDBosFrMgVW6GbXrqNtRSqq7biPHYHk/0AHAZvoGNQbFd4ALar7Fga+tXefT0oXIroVHv7SVQh5bmSxHYrNiGBi2nbEgo/OYjeXBa+k9xNQ9/RRJRXCNoPGTtvQ9FZBkP6YRg=;
X-YMail-OSG: Ts.d9yQVM1k49e3DQAxHUr6TIi3FuAT36rS6VCRahdSEFq2iyX4nDTbiN2AzgtYDD2YuKg--
Date: Mon, 5 Nov 2007 10:52:01 -0800 (PST)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [2.6 patch] move edac.txt DOCUMENTATION two levels up
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Adrian Bunk <bunk@kernel.org>
Cc: dougthompson@xmission.com, bluesmoke-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071105171733.307a562a@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <293742.55428.qm@web50101.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Interesting

At the time I submitted it there was a big discussion on just how messed up the documentation
directory was, inconsistent and not well laid out. Then more discussion on how it could be laid
out in relation to where various subsystem were laid out (ie drivers doc directory like there was
a drivers src directory and the like).

Therefore I placed it following that pattern.

So what I am hearing is that documentation for a subsystem should just continue to be dumped into
one directory with everything else.

Okay, if that is the goal, I am fine with, but things are pretty jumbled up in there. I will know
where it is at least.

doug t



--- Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Mon, 5 Nov 2007 18:06:08 +0100
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > There's no reason for edac.txt for being at this unusual place.
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> Acked-by: Alan Cox <alan@redhat.com>
> 
> 


W1DUG
