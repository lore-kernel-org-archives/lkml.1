Return-Path: <linux-kernel-owner+w=401wt.eu-S1751266AbYBJNa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751266AbYBJNa7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 08:30:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750859AbYBJNau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 08:30:50 -0500
Received: from keil-draco.com ([216.193.185.50]:50118 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbYBJNat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 08:30:49 -0500
From: Daniel Hazelton <dhazelton@enter.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Date: Sun, 10 Feb 2008 08:30:37 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Marcel Holtmann <marcel@holtmann.org>, davids@webmaster.com,
       David Newall <davidn@davidnewall.com>, Greg KH <greg@kroah.com>,
       Christer Weinigel <christer@weinigel.se>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <MDEHLPKNGKAHNMBLJOLKGEJHKDAC.davids@webmaster.com> <200802100007.50441.dhazelton@enter.net> <20080210112045.0035457c@core>
In-Reply-To: <20080210112045.0035457c@core>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802100830.37987.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 10 February 2008 06:20:45 Alan Cox wrote:
> > Why? Because the pre-processor is what is including any GPL'd code in my
> > application and expanding any macros. That is a purely mechanical process
> > and
>
> And its not pirating Windows because Norton Ghost put Microsoft copyright
> material in your hard disk either - thats a mechanical process too. Right
> - no. Nor can the gcc compiler hold the copyright as you suggest as it is
> not a legal person.

It takes someone telling the program to do it. The act of instructing the 
program is the actual "criminal" act. This is a 'Straw Man'. Next ? 

> The compiler might perform a process which combines your creative work
> with another and thus creates a derivative work. It might do that with
> libgcc. In many cases the FSF is being careful when it makes sure
> specific things don't happen just as Linus did with the kernel. Sometimes
> it is best to make sure no judge got a bit carried away and instead to
> create certainty in advance.

Yes, of course, and I'll never argue otherwise. However, what I was saying is 
that it is the claim of the FSF that, in no uncertain terms, a C program that 
uses the standard C library interface and is linked to glibc instead of, say, 
the old Borland libc, is automatically GPL because it's been linked to GPL 
code.

And in the case of the "Bison Exception", lets think of it this way... A 
company writes a configuration file parser and is selling the software to 
other companies for use on their Solaris and SysV machines. The board decides 
to sell the software for linux and the employee in charge of the linux build 
uses the standard GNU tools for the entire process, including Bison. Even 
without the exception it wouldn't make the program a derivative of Bison or 
even come close to  putting the code under the GPL.

> If you really think what you claim then I'll #include your entire work,
> flog it binary only and assure you it can't be derivative as you said so.
> That's entirely mechanical - in fact I can clain a defence of 'estoppel'
> given your previous statement, so you probably wouldn't be able to sue me
> for it even if it was otherwise a violation.

Straw man. Again.

But... You'd have fallen afoul of the "intent". Action follows intent, and so 
does the law. (At least in the US)

> There is btw lots of possibly useful caselaw in the area of books. People
> have spent time litigating and thus established some clearer answers to
> questions like whether you need copyright owners permission for

And I've actually read almost all the court cases that have a bearing on this. 
(I don't step into a discussion unprepared)

If the process of linking could create a derivative work, the *EVERY* program 
that runs on *ANY* OS would be a derivative of that OS, because the program 
is linked to the OS at run-time. 

DRH
PS: It is time for me to shut up now. I'm sick (bronchitis) and when sick, I 
tend to get very combative and come off like a troll.

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
