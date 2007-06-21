Return-Path: <linux-kernel-owner+w=401wt.eu-S1753185AbXFUXa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbXFUXa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 19:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751176AbXFUXaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 19:30:18 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:26441 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbXFUXaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 19:30:16 -0400
Date: Fri, 22 Jun 2007 01:30:15 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jesper Juhl <jesper.juhl@gmail.com>
cc: =?ISO-8859-1?Q?Zolt=E1n_HUBERT?= <zoltan.hubert@zzaero.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Please release a stable kernel Linux 3.0
In-Reply-To: <9a8748490706211529yca0588dgd1f7e0b86f7e4a62@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706220124050.26568@fbirervta.pbzchgretzou.qr>
References: <200706212349.54983.zoltan.hubert@zzaero.com>
 <9a8748490706211529yca0588dgd1f7e0b86f7e4a62@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-699020219-721175904-1182468615=:26568"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---699020219-721175904-1182468615=:26568
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT


On Jun 22 2007 00:29, Jesper Juhl wrote:
> On 21/06/07, Zoltán HUBERT <zoltan.hubert@zzaero.com> wrote:
> [snip]
>> All people who might read this know that traditionally
>> stable releases are even numbered and development branches
>> are odd numbered. This changed during late develoment of
>> 2.6, according to my analysis because of the "invention" of
>> GIT which was itself necessary because of BitKeeper (insert
>> ooooooooold flame-wars here) and which allowed very dynamic
>> develoment.
>[...]
> I myself have argued that we should be focusing more on stability and
> regression fixing, but I'm not so sure that a 2.6.7 devel branch would
> solve this. In general the 2.6.x.y -stable kernels seem to be doing
> the job pretty good.

For my part, I think the 2.6.<odd> did not go as well as the 2.6.<even>,
beginning with x=16.

>> Why on earth call "kernel object" things that are "kernel modules"
>> ? And that every person calls "modules" and not "objects" ? I know
>> I know, in UNIX dynamic libraries are .so "shared objects", so
>> what ? A "module" is a "module" and NOT an "object", call a cat a
>> cat.
>>
> It sure is an object, it's even called object code. I think the name
> suits just fine. In any case, it's just a name.

Back in the 2.4 days and e.g. on Solaris (still) today, a kernel
object file is [can be] a kernel module. Under Linux, this is not the
case anymore since 2.6.x when kbuild started to postprocess modules
(creating these nice .mod.c and .mod.o files and the benefits
associated with it).



	Jan
-- 
---699020219-721175904-1182468615=:26568--
