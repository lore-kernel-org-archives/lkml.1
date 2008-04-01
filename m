Return-Path: <linux-kernel-owner+w=401wt.eu-S1755503AbYDAMvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbYDAMvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 08:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbYDAMvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 08:51:16 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:58725 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbYDAMvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 08:51:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fs8SJX0DjWhcUqmI8HwGeGDQhy9rm9mA1m5f1XH7TVk0VbAcXYcu85os2XbBZtHtbfvt+q7M3qjRn8s5sOqMH7MoZNSY0NXYTn0gh8TDZ8cYN+4B3w2H6tZs3H82eHKS00IRY/XlM2mtJhh6UqI66VXj25oU1wA7DvHlBCloN9Q=
Message-ID: <e1e1d5f40804010551q392b7717pf3004f804e154c6a@mail.gmail.com>
Date: Tue, 1 Apr 2008 09:51:15 -0300
From: "Daniel Bonekeeper" <thehazard@gmail.com>
To: "Peter Teoh" <htmldeveloper@gmail.com>
Subject: Re: RFC: Writing Solaris Device Drivers in Java
Cc: "Jacek Luczak" <difrost.kernel@gmail.com>,
       "Peter Zijlstra" <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>
In-Reply-To: <804dabb00803310754q40eaca5ai8b9faacecef0edef@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47F0491F.4050804@gmail.com> <1206959293.8514.636.camel@twins>
	 <47F0D201.6030102@gmail.com>
	 <804dabb00803310754q40eaca5ai8b9faacecef0edef@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2008 at 11:54 AM, Peter Teoh <htmldeveloper@gmail.com> wrote:
> On Mon, Mar 31, 2008 at 7:58 PM, Jacek Luczak <difrost.kernel@gmail.com> wrote:
>  > Peter Zijlstra pisze:
>
> >  >
>  >  Java? Compete against C? Don't scare embedded devs.
>  >
>
>  The future is always uncertain for us.   Embedded development usually
>  emphasizes on performance, unlike those of the desktop.   So which
>  language will be king tomorrow in embedded, it boils down to
>  performance + optimization + ease of development.   Just imagine:
>  from 10 lines of C reduced to 2 lines of XXX-based language software -
>  I think the 10 lines will scare off the embedded developers of
>  tomorrow.    I may be wrong :-).

I hope you are... otherwise I may not have the necessary patience to
cope with such people in the future =)
It's funny how people nowadays are dumbing down languages & systems to
fit expectations of how easy programming should be [for a newbie]...

One thing that I can live with is the fact that program interfaces are
getting dumber by the week so that the "general user" can use them
without thinking too much.

Another thing that I cannot accept is people who call themselves
developers wanting to push stuff like Java where it doesn't belong to
make it easier on the kids who're entering the field (maybe on
themselves ?), who are supposed to know how the computer works, live
with it and actually like it, specially the low level stuff.

Who would trust a surgeon who's afraid of a little blood ?

On the other hand, it's always good to know that there will always be
a need for the real programmers, apparently =)

-- 
What this world needs is a good five-dollar plasma weapon.
