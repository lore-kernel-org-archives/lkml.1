Return-Path: <linux-kernel-owner+w=401wt.eu-S1755156AbZIPDWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156AbZIPDWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 23:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbZIPDWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 23:22:13 -0400
Received: from mail-yw0-f180.google.com ([209.85.211.180]:33623 "EHLO
	mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbZIPDWN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 23:22:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=PKCNTaGIKEeUnmnbkfhhHMJqDOYvstFjaUHFRfap9sgW/SIOLAx0JE/uOM/+oHjCsO
         C9L83H3CLQRM0fsC+TuCEkhhCmJBYrlZ+RQvBvm5NuwAFSEV/iYGDl+l9yJp83ZlETHD
         miPwFFHLmeiU8gZypvGJ9hEg5uGFZvNO7MJAs=
MIME-Version: 1.0
In-Reply-To: <1253070408.11643.540.camel@desktop>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org> 
	<1252961412.11643.215.camel@desktop> <8bd0f97a0909141357y60d7807bm99146d757e6f61da@mail.gmail.com> 
	<1252962263.11643.232.camel@desktop> <8bd0f97a0909141407i26b39f9bq133a62be381601b5@mail.gmail.com> 
	<1252963292.11643.259.camel@desktop> <8bd0f97a0909141517i3535bb84j4cbac0cd986d4914@mail.gmail.com> 
	<1252967767.11643.286.camel@desktop> <8bd0f97a0909151956k6cc20944we1ccb6c5188c4edb@mail.gmail.com> 
	<1253070408.11643.540.camel@desktop>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 15 Sep 2009 23:21:56 -0400
Message-ID: <8bd0f97a0909152021p71eb7be4mfaae4e1af5876740@mail.gmail.com>
Subject: Re: [PATCH 00/72] Blackfin updates for 2.6.32
To: Daniel Walker <dwalker@fifo99.com>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 23:06, Daniel Walker wrote:
> On Tue, 2009-09-15 at 22:56 -0400, Mike Frysinger wrote:
>> On Mon, Sep 14, 2009 at 18:36, Daniel Walker wrote:
>> > If you ultimately don't correct these changes, I'd ask that in the
>> > future you submit pull requests for the blackfin architecture instead of
>> > sending individual patches ..
>>
>> you havent been following anything related to how Blackfin (or any
>> arch?) patches are merged.  this patch series is for review only from
>> my tree.  no one is picking these up because they've already been
>> picked up.
>
> Picked up by Linus? You know this isn't the "blackfin" list right? You
> don't seem to care too about review your getting from _this_ list. So
> why in the world are you sending your patches (all 72 of them!) here ..

Linus doesnt pick up random patches, he does pull requests.  Blackfin
patches already get reviewed on the Blackfin list (during original
commit and later merge).  i post all the patches for sanity checking
things we may have missed (it happens).  any sane mailer makes it
trivial to delete/ignore a single thread, and for anyone reading LKML,
not using a sane mailer is a poor excuse.  i'm open to review of real
issues with the code (locking / leaks / design problems / etc...).
forcing a respin of patches for a minor style difference is noise.
-mike
