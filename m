Return-Path: <linux-kernel-owner+w=401wt.eu-S1751497AbXBPOyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497AbXBPOyZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 09:54:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbXBPOyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 09:54:24 -0500
Received: from yumi.tdiedrich.de ([85.10.210.183]:4070 "EHLO yumi.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbXBPOyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 09:54:23 -0500
Date: Fri, 16 Feb 2007 15:54:17 +0100
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: Jeff Garzik <jeff@garzik.org>, Ayaz Abdulla <aabdulla@nvidia.com>,
       David Ford <firefighterblu3@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: forcedeth problems on 2.6.20-rc6-mm3
Message-ID: <20070216145417.GC5388@melchior.yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	Jeff Garzik <jeff@garzik.org>, Ayaz Abdulla <aabdulla@nvidia.com>,
	David Ford <firefighterblu3@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Robert Hancock <hancockr@shaw.ca>,
	linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
References: <45C6BCE5.90103@shaw.ca> <20070204213603.a5bce839.akpm@linux-foundation.org> <45C6C531.20508@shaw.ca> <20070204221741.63152cbe.akpm@linux-foundation.org> <523e55a00702081326j43de05e3hdd8cf35e946eae9@mail.gmail.com> <45CBE30D.5030006@nvidia.com> <20070209115821.GD10330@melchior.yamamaya.is-a-geek.org> <20070209120730.GA11911@melchior.yamamaya.is-a-geek.org> <45CC8A2D.20509@garzik.org> <20070212062823.GB4756@melchior.yamamaya.is-a-geek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070212062823.GB4756@melchior.yamamaya.is-a-geek.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tobias Diedrich wrote:
> Jeff Garzik wrote:
> > Tobias Diedrich wrote:
> > >Tobias Diedrich wrote:
> > >>Ayaz Abdulla wrote:
> > >>>For all those who are having issues, please try out the attached patch.
> > >>Will try.
> > >
> > >Does not apply cleanly against 2.6.20, is this one fixed up right?
> > 
> > It probably needs to be top of 2.6.20-git-latest or 2.6.20-rc6-mm3.
> > 
> > IOW, the forcedeth changes in question are not in 2.6.20, and you need 
> > to apply the patch on top of the latest batch of forcedeth changes.
> 
> Well, it hasn't blown up on me despite being applied to 2.6.20...
> The problem I was seeing might even be fixed in 2.6.20 vanilla,
> since the last version I saw it in was 2.6.20-rc6 and then I
> reverted to 2.6.19 to make sure that one is ok (see
> 20070130183208.GE11814@melchior.yamamaya.is-a-geek.org).

And having run vanilla 2.6.20 since my last mail, I haven't seen the
problem on that one either.
So I _guess_ the particular problem I was seeing was fixed somewhere
between 2.6.20-rc6 and 2.6.20.  But since I can't reliably trigger
it, I can't say that for sure.

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
このメールは十割再利用されたビットで作られています。
