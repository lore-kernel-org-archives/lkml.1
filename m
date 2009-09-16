Return-Path: <linux-kernel-owner+w=401wt.eu-S1751230AbZIPENo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751230AbZIPENo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 00:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750766AbZIPENm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 00:13:42 -0400
Received: from mail-yw0-f180.google.com ([209.85.211.180]:39989 "EHLO
	mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbZIPENl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 00:13:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=PIigY3JzTzU51tt50qd9a7BbWDUgj5MM4hHTBAmUXrwf4WvMd3SM7as0iKa+mCvCfi
         IHNaB1VkYIzn8jj3hQGLqGHKiiYmZ2a6BJ850C/3195b0b4KSxQSzNF49IxnJdXhOohT
         BppbYMJLyqG4chtxkFFra0bzB/o//0Z1OiTF0=
MIME-Version: 1.0
In-Reply-To: <1253073550.11643.562.camel@desktop>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org> 
	<1252962263.11643.232.camel@desktop> <8bd0f97a0909141407i26b39f9bq133a62be381601b5@mail.gmail.com> 
	<1252963292.11643.259.camel@desktop> <8bd0f97a0909141517i3535bb84j4cbac0cd986d4914@mail.gmail.com> 
	<1252967767.11643.286.camel@desktop> <8bd0f97a0909151956k6cc20944we1ccb6c5188c4edb@mail.gmail.com> 
	<1253070408.11643.540.camel@desktop> <8bd0f97a0909152021p71eb7be4mfaae4e1af5876740@mail.gmail.com> 
	<1253073550.11643.562.camel@desktop>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 16 Sep 2009 00:13:25 -0400
Message-ID: <8bd0f97a0909152113v2f01d1eem6b57a1673f9b317b@mail.gmail.com>
Subject: Re: [PATCH 00/72] Blackfin updates for 2.6.32
To: Daniel Walker <dwalker@fifo99.com>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 23:59, Daniel Walker wrote:
> On Tue, 2009-09-15 at 23:21 -0400, Mike Frysinger wrote:
>> On Tue, Sep 15, 2009 at 23:06, Daniel Walker wrote:
>> > On Tue, 2009-09-15 at 22:56 -0400, Mike Frysinger wrote:
>> >> On Mon, Sep 14, 2009 at 18:36, Daniel Walker wrote:
>> >> > If you ultimately don't correct these changes, I'd ask that in the
>> >> > future you submit pull requests for the blackfin architecture instead of
>> >> > sending individual patches ..
>> >>
>> >> you havent been following anything related to how Blackfin (or any
>> >> arch?) patches are merged.  this patch series is for review only from
>> >> my tree.  no one is picking these up because they've already been
>> >> picked up.
>> >
>> > Picked up by Linus? You know this isn't the "blackfin" list right? You
>> > don't seem to care too about review your getting from _this_ list. So
>> > why in the world are you sending your patches (all 72 of them!) here ..
>>
>> Linus doesnt pick up random patches, he does pull requests.  Blackfin
>> patches already get reviewed on the Blackfin list (during original
>> commit and later merge).  i post all the patches for sanity checking
>> things we may have missed (it happens).  any sane mailer makes it
>> trivial to delete/ignore a single thread, and for anyone reading LKML,
>> not using a sane mailer is a poor excuse.  i'm open to review of real
>> issues with the code (locking / leaks / design problems / etc...).
>> forcing a respin of patches for a minor style difference is noise.
>
> I read all of LKML, sane mailer or not _your_ patches are noise .. You
> have your own mailing list. You have no good reason to post that many
> patches here, and it's more than likely no one is reviewing them (except
> me, and your ignoring my valid comments) .. If you have specific patches
> that have questionable "locking, leaks, or design problems" that's
> welcome, but not what your doing..

if i thought something had questionable code, i'd of fixed it myself,
or specifically asked someone.  if the larger lkml community would
prefer to not see the patch series for review, i have no program
refraining, but i havent seen a negative response so far.  i have seen
some random fixes which were certainly nice.
-mike
