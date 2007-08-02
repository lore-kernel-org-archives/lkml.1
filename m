Return-Path: <linux-kernel-owner+w=401wt.eu-S1755634AbXHBOrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634AbXHBOrA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 10:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbXHBOqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 10:46:51 -0400
Received: from web52507.mail.re2.yahoo.com ([206.190.48.190]:47597 "HELO
	web52507.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751953AbXHBOqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 10:46:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=JchfvWEW+0scqpyARyu3uNUQ18r6P0mHrxF74K+uGew/DFZNhKu3BeoeyCE+n808kWucz9R6NlDsftimnRN21cFI1RmNIjfIvnHDO/ShSKLCyJXPbtOfeOBHJWhwoyRuCYRIgmBFmdRx86VofVjUu704ElqwsUPdnXkk/3POP4g=;
X-YMail-OSG: 0Yl4FZQVM1mVKbrelQMlJe9fbjrKn4mOucf96immutL_B8fT0QmjYqZMgHNnfeqA8xIUe9cNekBPT0TazObaj2TCcjVXAQ380GfW3r_Y6yrEqCwlkv0-
Date: Thu, 2 Aug 2007 07:46:49 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Re: Woke up to a crashed kernet this morning - nVidia is crap
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <6bffcb0e0708020728x5751fc76pad5deadce3a21a5b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <898083.40014.qm@web52507.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

OK - so the driver I downloaded from nVidia to fix
their problem I was having with the video installed
drivers for everything? I'm really getting to dislike
nVidia.


--- Michal Piotrowski
<michal.k.k.piotrowski@gmail.com> wrote:

> 
> Nvidia binary crap
> 
> "    When you are using a binary driver, the kernel
> is "tainted",
> which means that the source
> of possible problems may be unrelated to the kernel
> code (see
> https://secure-support.
>
novell.com/KanisaPlatform/Publishing/250/3582750_f.SAL_Public.html
> for more de-
> tails). You can check whether or not the kernel was
> tainted when the
> problem occurred by
> looking at the corresponding error message. If can
> you see something
> similar to the following
> line:
> EIP:       0060:[<c046c7c3>]        Tainted: P     
> VLI
> (the word Tainted is crucial here), the kernel was
> tainted and most
> probably the kernel
> developers will not be able to help you. In that
> case you should try
> to reproduce the problem
> without the binary driver loaded. Moreover, if the
> problem does not
> occur without it, you
> should send a bug report to the creators of the
> binary driver and ask
> them to ﬁx it.
>     In the ﬁle Documentation/oops-tracing.txt,
> included in the kernel
> sources, there is a
> list of reasons why the kernel can be considered as
> tainted. As
> follows from this document,
> the presence of a binary module is not the only
> possible reason of
> tainting the kernel, but
> in practice it turns out to be the most frequent
> one. Generally, you
> should avoid reporting
> problems in tainted kernels to the LKML (or to the
> kernel developers
> in general) and the
> problems related to binary drivers should be
> reported to their providers."
> 
> -- Linux Kernel Tester's Guide
> 
> Regards,
> Michal
> 
> -- 
> LOG
> http://www.stardust.webpages.pl/log/
> 



       
____________________________________________________________________________________
Moody friends. Drama queens. Your life? Nope! - their life, your story. Play Sims Stories at Yahoo! Games.
http://sims.yahoo.com/  
