Return-Path: <linux-kernel-owner+w=401wt.eu-S1758579AbXFCEJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758579AbXFCEJl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 00:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbXFCEJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 00:09:33 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:36480 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbXFCEJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 00:09:33 -0400
Date: Sat, 2 Jun 2007 21:06:14 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Scott Preece" <sepreece@gmail.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Adrian Bunk" <bunk@stusta.de>, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/1] document Acked-by:
Message-Id: <20070602210614.75862701.randy.dunlap@oracle.com>
In-Reply-To: <7b69d1470706021957t4d6a1b43k33c0766b27975f31@mail.gmail.com>
References: <200706010209.l51299kN000531@shell0.pdx.osdl.net>
	<20070602141144.GC5500@stusta.de>
	<20070602104700.53b6b811.akpm@linux-foundation.org>
	<7b69d1470706021957t4d6a1b43k33c0766b27975f31@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Jun 2007 19:57:41 -0700 Scott Preece wrote:

> On 6/2/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > ...
> > +The Signed-off-by: tag implies that the signer was involved in the development
> ---
> 
> Change "implies" to "indicates" - it's an explicit statement, not an
> implication.
> 
> ---
> > +of the patch, or that he/she was in the patch's delivery path.
> > +
> > +If a person was not directly involved in the preparation or handling of a
> > +patch but wishes to signify and record their approval of it then they can
> > +arrange to have an Acked-by: line added to the patch's changelog.
> > +
> > +Acked-by: is often used by the maintainer of the affected code when that
> > +maintainer neither contributed to nor forwarded the patch themselves.
> ---
> 
> This using plural pronouns for indefinite gender leaves one in vague
> territory, but I think "themself" would be better than "themselves,
> since "maintainer" is singular.

ugh.  :(
not-acked-by: /me

I would like to say "no such word," but I googled it and found lots of
references to it, most of which say "sub-standard," "nonstandard,"
"mythical," "vulgar," or "colloq."  But my search was not exhaustive.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

http://www.urbandictionary.com/define.php?term=themself
http://itre.cis.upenn.edu/~myl/languagelog/archives/004285.html
http://en.wiktionary.org/wiki/themself
http://www.allwords.com/word-themself.html
