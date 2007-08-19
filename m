Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbXHSPcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbXHSPcQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 11:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbXHSPcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 11:32:06 -0400
Received: from web52509.mail.re2.yahoo.com ([206.190.48.192]:48104 "HELO
	web52509.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751196AbXHSPcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 11:32:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=biHBZACfhH8QCtUBlPpmy/u3/O1w6x1zBwImKefXriIDzIrZo7V8XU8JbBFIidJ/JiPluqkg4ahrHOgJJojdBd0J8V62KN5wMFkLN9+iWiufSdn6Nbm1ZRf0Z3h1KEjJru+55T+DrHKuyXrjfETFOUIaLMmRYqnS0HJrQrEe3GM=;
X-YMail-OSG: DQPFJKkVM1myt2NkoaWgJG3Wx4hKqAhu4G3iAEL4EbBS0IUtJgNQLl.cCFs1unthYY4Bf5B5EknhmWNYUyzD.bLs.ivHS4haNDj3TP45yNWzORCnCXaxkum5gAfnNA--
Date: Sun, 19 Aug 2007 08:32:01 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Re: The vi editor causes brain damage
To: Paolo Ornati <ornati@fastwebnet.it>
Cc: Willy Tarreau <w@1wt.eu>, Jiri Slaby <jirislaby@gmail.com>,
       Marc Perkel <mperkel@yahoo.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070819164835.010f0e5b@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <828976.87242.qm@web52509.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Paolo Ornati <ornati@fastwebnet.it> wrote:

> On Sun, 19 Aug 2007 06:22:37 -0700 (PDT)
> Marc Perkel <mperkel@yahoo.com> wrote:
> 
> > 20 years, a million programmers, tens of millions
> of
> > users and RM is BROKEN. Am I the only one who has
> a
> > problem with this? If so - I'm normal - and Linux
> is a
> > cult.
> 
> 
> Fixed in 2.6.23-rc (and not just for "rm"):
> 
> commit b6a2fea39318e43fee84fa7b0b90d68bed92d2ba
> Author: Ollie Wild <aaw@google.com>
> Date:   Thu Jul 19 01:48:16 2007 -0700
> 
>     mm: variable length argument support
> 
>     Remove the arg+env limit of MAX_ARG_PAGES by
> copying the strings
>     directly from the old mm into the new mm.
> [...]
> 
> -- 
> 	Paolo Ornati
> 	Linux 2.6.23-rc3-g2a677896-dirty on x86_64
> 


Good man!



Marc Perkel
Junk Email Filter dot com
http://www.junkemailfilter.com


      ____________________________________________________________________________________
Luggage? GPS? Comic books? 
Check out fitting gifts for grads at Yahoo! Search
http://search.yahoo.com/search?fr=oni_on_mail&p=graduation+gifts&cs=bz
