Return-Path: <linux-kernel-owner+w=401wt.eu-S1757916AbYGPGzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916AbYGPGzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 02:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbYGPGz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 02:55:26 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:30084 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbYGPGz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 02:55:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=sAilwZcSy2XUHJI3AJ35SOyVUgr1fpQiAxCHKGUJPVSdqkdI1pTu5jg4FTRAJJH3gF
         a6L42JFujphz5xkyc7ilC/QoLebT4rlBeQp+kN3pDfTPP4C7hylVuZyjFilm0Gz5hgwH
         PQYyGezeiwykIxBcSJUG5RILZ38iy1tT4nI+w=
Message-ID: <487D9B58.7070609@gmail.com>
Date: Wed, 16 Jul 2008 03:55:20 -0300
From: "Rafael C. de Almeida" <almeidaraf@gmail.com>
User-Agent: Icedove 1.5.0.14eol (X11/20080509)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: From 2.4 to 2.6 to 2.7?
References: <6d291e080807141910m573b29b2t753ea7c4db09902d@mail.gmail.com> <alpine.LFD.1.10.0807141914280.3017@woody.linux-foundation.org> <487CE6CB.9090405@zytor.com> <487D7781.6000407@keyaccess.nl>
In-Reply-To: <487D7781.6000407@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> On 15-07-08 20:04, H. Peter Anvin wrote:
> 
>> Clearly, the 2. prefix has long outlived its usefulness as far as
>> Linux is concerned, and probably the 6 as well.
> 
> Been calling the -stable branches v20, v21, v22, ... here.
> 
> I do believe the numbering scheme should at least ostensibly still be
> feature driven, not be a fully robotic date thing. With the latter, you
> definitely miss out on press-opportunities and that's not even meant
> cynical. There just is a bit of industry around Linux and the promotion
> opportunities of (say) "Linux 3" are really lots, lots bigger than
> anything boringly date based.

And that's why after the adoption of generics and a few things java all
the sudden became java 5. I don't like that. I hope the world gets used
to learning things instead of just being driven by a pretty number. And
I think that not using marketing numbers on a popular software is a good
step into helping people realise that version numbers are meant to keep
track of the changes not to look cool.

> That even holds for things like books -- I just bet that a "all new,
> covers Linux 3!" blurp on the cover sells lots more copies than a "all
> new, covers the march 21st 2009 version of Linux!" one.

I rather just have good books around. I can bet that all -- or at least
most of -- those new "LINUX 3!" books would suck. So it's better if they
sell little or not sell at all.

> But yes, the current monotic increase is definitely getting a bit boring
> as well. The kernel as of 2.6.26 is quite different from the kernel that
> was known as 2.6.0 so just be creative I'd say and set a 2.8 goal. Next
> version can be 2.9 (should be clear enough by then) and then watch world
> domination happen with the big 3.0 release.

Well, if 2.6.0 was 3.0 (2003.0) then people would easily realise that
they're missing 5 years of kernel development. Given that hint, if they
take a look on a few Changelogs they'll soon find out they're missing on
quite a lot.

> Linux 2010.5? Boooooooooring....

Well, it is software versioning and not Gisele Bündchen taking off her top.

> Rene.
