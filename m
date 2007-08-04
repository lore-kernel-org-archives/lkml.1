Return-Path: <linux-kernel-owner+w=401wt.eu-S933155AbXHDTY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933155AbXHDTY5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 15:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765132AbXHDTYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 15:24:48 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:39964 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760939AbXHDTYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 15:24:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dajxv+5pozZD3r7tbwHJOWYS+o5+/AKxJVjhf+LgfKvwsuMJQy32SMx63l/D2DmtwmiZffPh0Thj9HLLj4EwO5bbBKCQBk8NXm8dc80eTb3/+lwaaw/Krt0AvaGHhzDaqIfXgKGV1M1aduorOvOjZMl/Ahs2PQP+3LlZa2kSxHw=
Message-ID: <9a8748490708041224s43bf9c1wcfecf1f7bb4e3055@mail.gmail.com>
Date: Sat, 4 Aug 2007 21:24:46 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Rob Landley" <rob@landley.net>
Subject: Re: [PATCH 1/2] Group architecture Documentation under Documentation/arch.
Cc: "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "Roland Dreier" <rdreier@cisco.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       linux-doc@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       "Paul Mundt" <lethal@linux-sh.org>
In-Reply-To: <200708041422.04493.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705222225.39949.rob@landley.net>
	 <200708041404.01264.rob@landley.net>
	 <9a8748490708041207t5ba8063s4a75eabc4c8db8b6@mail.gmail.com>
	 <200708041422.04493.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/07, Rob Landley <rob@landley.net> wrote:
> On Saturday 04 August 2007 2:07:31 pm Jesper Juhl wrote:
> > On 04/08/07, Rob Landley <rob@landley.net> wrote:
> > > Signed-off-by: Rob Landley <rob@landley.net>
> > > Amiga part Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > >
> > > Move architecture-specific Documentation into a common subdirectory.
> >
> > ...
> >
> > I have only one complaint; I don't see an update to Documentation/00-INDEX
>
> I now have at least three.  (I missed blackfin, which wasn't there last time I
> did this.)
>
I'm not talking about Documentation/<arch>/00-INDEX, but the 00-INDEX
file in the top-level Documentation directory.

Or am I misunderstanding you?

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
