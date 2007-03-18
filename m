Return-Path: <linux-kernel-owner+w=401wt.eu-S1752609AbXCRN5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbXCRN5L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 09:57:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbXCRN5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 09:57:11 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:44337 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbXCRN5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 09:57:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=W0IJRgGvW+v4zdWpFX22U7kgQoDt28jaKJuraZqawZe0/re5pCRIYdvvAsrtccTqmfA/ay1W8ena+P+d3YwGLwIgwwwzpQzz69EQkOj4mtexEWsX6wEKD9nofARqOWxnYeWG7Jk6o0mmaDo0bDTRhciLvYE8JQlbTrGnpUGNuZY=
Message-ID: <3aa654a40703180657r4f025daag993c3e06a3a16c69@mail.gmail.com>
Date: Sun, 18 Mar 2007 06:57:08 -0700
From: "Avuton Olrich" <avuton@gmail.com>
To: "Kasper Sandberg" <lkml@metanurb.dk>
Subject: Re: [ck] Re: RSDL v0.31
Cc: "Mike Galbraith" <efault@gmx.de>,
       "Radoslaw Szkodzinski" <astralstorm@gmail.com>,
       "Al Boldi" <a1426z@gawab.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, ck@vds.kolivas.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Nicholas Miell" <nmiell@comcast.net>
In-Reply-To: <1174211853.10498.25.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703042335.26785.a1426z@gawab.com>
	 <200703172048.46267.kernel@kolivas.org>
	 <1174125534.7734.2.camel@Homer.simpson.net>
	 <200703172355.30989.a1426z@gawab.com>
	 <1174198651.8199.44.camel@Homer.simpson.net>
	 <1174200463.10498.23.camel@localhost>
	 <1174201726.8732.6.camel@Homer.simpson.net>
	 <f44c5fdf0703180022n44b2ca61o62602e54aaab3334@mail.gmail.com>
	 <1174203482.8855.8.camel@Homer.simpson.net>
	 <1174211853.10498.25.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/18/07, Kasper Sandberg <lkml@metanurb.dk> wrote:
> not really, only X sucks. KDE works atleast as good with rsdl as
> vanilla. i dont know how originally said kde works worse, wasnt it just
> someone that thought?

Couldn't agree more, been using RSDL+KDE for a week now, and as far as
I'm concerned I will be sticking with this until it goes to mainline,
or mainline exhibits better behaviour. The fact of the matter is I was
always unsure why windows 'feels' so much better than linux. RSDL
makes it feel like windows, all the time, no matter what's going on.
I'm really miffed when anyone talks about regressions, because I have
scenarios that will completely lock up linux for 10s or so on my
athlon 4200x2, due to [really] poorly designed apps that I need to
run. RSDL seems to work right though it; it works faster, mouse feels
better, browser scrolls smoothly, can't make the sound skip, video is
fluid, opening a term is instant, boot up is faster, all which are a
step up from mainline. That's the facts. IME I have seen nothing but
good with RSDL.


-- 
avuton
--
 Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
