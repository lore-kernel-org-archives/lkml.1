Return-Path: <linux-kernel-owner+w=401wt.eu-S1753383AbXFUGIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbXFUGIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 02:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750769AbXFUGIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 02:08:35 -0400
Received: from barikada.upol.cz ([158.194.242.200]:54016 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbXFUGIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 02:08:35 -0400
To: Ben Pfaff <blp@cs.stanford.edu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       postmaster@vger.kernel.org, webguy@theaimsgroup.com,
       postmaster@lkml.org, postmaster@ussg.iu.edu
Subject: Re: Request for Linux Kernel Mailing List archives
In-Reply-To: <87sl8mbioi.fsf@blp.benpfaff.org>
References: <467949CC.9090405@zytor.com> <87sl8mbioi.fsf@blp.benpfaff.org>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: jed (x86_64-pc-linux-glibc-debian)
X-Mailer: slrn
Date: Thu, 21 Jun 2007 08:21:03 +0200
Message-Id: <E1I1G2R-00058L-JT@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Newsgroups: gmane.linux.kernel
* Date: Wed, 20 Jun 2007 11:10:53 -0700
>
>> For example, if a message had:
>>
>> Message-ID: <4676C78D.8040208@zytor.com>
>>
>> ... and I could just generate a URL:
>>
>> http://linux-kernel.example.com/msgid/4676C78D.8040208@zytor.com
>
> gmane can do that:
>         http://mid.gmane.org/4676C78D.8040208@zytor.com

To have Gmane (news<=>e-mail [and web]) engine[s] on the kernel.org will
be the best thing ever!

The "News<=>e-mail" part is major because of things, i've learned after
using it with (_mature_ news reader) slrn. Any web interface, basic like
in marcs.info, or comprehensive, like Gmane's one can't replace
functionality news server(Gmane)/reader is giving to you (summary):

* You don't receive (or annoyingly bounce) huge traffic.
  . big backlogs are handled easily in many cases, like getting
    e-mails, replying in interesting threads, just don't care about
    flames. I've just removed (by one key-press) 300, 200, 100 messages
    of Dual-Licensing thread, because i trust Linus.

* Interesting discussions are easily saved(by threads) on your side, so
  you can search them or read (any mbox format reader, like `mutt -f`)

* (slrn) Searching Message-Id as easy as one key-combination and one
  copy/paste {1}

* (slrn) Restoring of whole thread from one e-mail (or {1}) -- one
  key-combination

* (slrn + Gmane) headers have "Archived-At" entry, so i can just
  copy/paste it for web-based users

* (slrn + Gmane) listing of news-groups (actually ML<=>Gmane-NEWS)
  as easy as all above: patterns, one key-combination
  
* i bet much more, than i've just told.

And that's pretty why i'm happy to be with. After abandoning Mozilla
(buggy, memory hungry ever stuff), X and having console, screen, slrn,
lynx, emacs-nox i'm a pretty much more efficient that any time back.

All web, rss, other XML/WEB-2.0 crap does will not help. Get your
developers back -- use and publish healthy ways and tools to use!

I mean, come on, that's easy, rather than develop IMHO useless
e-mail/patch brokenness (WRT plain-text) checkers and docs.

Publish your way of being productive and saving environment! (tm:)

>> (Extra points if all the vger lists are available, not just LKML.)
>
> gmane has thousands of free software mailing lists.  I don't know
> whether it has all of the vger lists.

There are many, that i'm aware of: kernel, commits, ide, net, usb,
archs(amd64 at least), sparse, git...

Namespace in Gmane is a little bit wrong. For example
gmane.linux.kernel and gmane.linux.debian.*

I.e. Linux kernel (with sub-parts) is in noise of distributions, while
latter can have different kernel actually (e.g. kfreebsd in the Debian).
____
