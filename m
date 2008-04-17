Return-Path: <linux-kernel-owner+w=401wt.eu-S932639AbYDQRzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639AbYDQRzK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 13:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760821AbYDQRyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 13:54:54 -0400
Received: from web50210.mail.re2.yahoo.com ([206.190.38.51]:28684 "HELO
	web50210.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760400AbYDQRyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 13:54:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=UribFx2RsTELKqQRsRkwJVe5jN6PwiatzdvoP6rhTyKj2GvnKlvuII1VId2YoTHBeaIT+0DyBDTWq9OsrfUkIK2/KSBfdC6W4FUN8OHEr6gJS7plFxnb+BP7w/EOwSUyUmaHeA+NRk5zRrbCvH9NzYEhRBBUcA6yybHh4U9FhUs=;
X-YMail-OSG: 3HTsNroVM1m7OV4EpzRzftKBekzjRE0SYO19SU8UVidUuNXcW6xFNkNIHtvMkdTRRY0u_x0zcQKy.YF_7De_c3jow.eeKLw-
X-Mailer: YahooMailWebService/0.7.185
Date: Thu, 17 Apr 2008 10:54:52 -0700 (PDT)
From: Alex Davis <alex14641@yahoo.com>
Reply-To: alex14641@yahoo.com
Subject: Re: [patch 00/66] 2.6.24-stable review
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org, chrisw@sous-sol.org, netdev@vger.kernel.org
In-Reply-To: <20080417173313.GA1962@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <574974.75592.qm@web50210.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



I code, therefore I am


--- On Thu, 4/17/08, Adrian Bunk <bunk@kernel.org> wrote:

> From: Adrian Bunk <bunk@kernel.org>
> Subject: Re: [patch 00/66] 2.6.24-stable review
> To: "Alex Davis" <alex14641@yahoo.com>
> Cc: linux-kernel@vger.kernel.org, chrisw@sous-sol.org, netdev@vger.kernel.org
> Date: Thursday, April 17, 2008, 1:33 PM
> On Thu, Apr 17, 2008 at 08:05:56AM -0700, Alex Davis wrote:
> > Apologies to anyone who receives this message twice.
> > 
> > Is the patch referenced in
> http://lkml.org/lkml/2008/4/10/409 necessary 
> > for stable? 
> 
> It's a 2.6.25-rc regression fixed in 2.6.25.
>
> cu
> Adrian
Thanks. I just looked at the 2.6.24.4 version of the same file and,
seeing that the section of code the patch applied to was the same,(erroneously) assumed the patch might be needed.


> -- 
> 
>        "Is there not promise of rain?" Ling Tan
> asked suddenly out
>         of the darkness. There had been need of rain for
> many days.
>        "Only a promise," Lao Er said.
>                                        Pearl S. Buck -
> Dragon Seed


      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ
