Return-Path: <linux-kernel-owner+w=401wt.eu-S1751468AbXDMCkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468AbXDMCkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 22:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbXDMCkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 22:40:19 -0400
Received: from mx33.mail.ru ([194.67.23.194]:16511 "EHLO mx33.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbXDMCkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 22:40:17 -0400
Date: Fri, 13 Apr 2007 06:36:59 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Shem Multinymous <multinymous@gmail.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Paul Sokolovsky <pmiscml@gmail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org
Subject: Re: [Kernel-discuss] Re: [PATCH 3/7] [RFC] Battery monitoring class
Message-ID: <20070413023659.GA17467@zarina>
Reply-To: cbou@mail.ru
References: <20070411232503.GC20095@zarina> <20070412130817.GA29900@srcf.ucam.org> <20070412141505.GA25552@zarina> <20070412142430.GA31240@srcf.ucam.org> <1734853889.20070412173626@gmail.com> <20070412185630.GC27804@khazad-dum.debian.net> <20070412204413.GA3151@zarina> <20070413005112.GA20890@khazad-dum.debian.net> <41840b750704121934g2771cc0er308eb4f9c8a1cb80@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <41840b750704121934g2771cc0er308eb4f9c8a1cb80@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 10:34:06PM -0400, Shem Multinymous wrote:
> Hi,
> 
> On 4/12/07, Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
> >On Fri, 13 Apr 2007, Anton Vorontsov wrote:
> >> * Yup, I've read last discussion regarding batteries, and I've seen
> >>   objections against "charge" term, quoting Shem Multinymous:
> >>
> >>   "And, for the reasons I explained earlier, I strongly suggest not using
> >>   the term "charge" except when referring to the action of charging.
> >>   Hence:
> >>   s/charge_rate/rate/;  s/charge/capacity/"
> >>
> >>   But lets think about it once again? We'll make things much cleaner
> >>   if we'll drop "capacity" at all.
> >
> >I stand with Shem on this one.  The people behind the SBS specification
> >seems to agree... that specification is aimed at *engineers* and still
> >avoids the obvious trap of using "charge" due to its high potential for
> >confusion.
> >
> >I don't even want to know how much of a mess the people writing applets
> >woudl make of it...
> 
> With fixed-units files, having *_energy and *_capacity isn't too clear
> either... Nor is it consistent with SBS, since SBS uses "capacity" to
> refer to either energy or charge, depending on a units attribute.
> 
> As a compromise, how about using "energy" and "charge" for quantities,
> and "charging" (i.e., a verb) when referring to the operation?

It would be great compromise! Please please please!

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.org/bd2
