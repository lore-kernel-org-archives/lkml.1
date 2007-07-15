Return-Path: <linux-kernel-owner+w=401wt.eu-S1758463AbXGOXPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758463AbXGOXPH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 19:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760798AbXGOXOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 19:14:51 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:26166 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759999AbXGOXOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 19:14:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Y60v2OfiDkO+lqUQmQ9jtGljaq2WMiIQFZzrnYeDvQpX95wP5YIWa+elmu5SI7APmIWwoYOhXJF0AUg8yd0S+yk5ChM5EASns53BfUz0snD8lYJZSEHcdPNfbvwZiWoXRPXuSgk2UqCd4CloM9X4/Kkb3gKQMArCWjfNroTSqEk=
Message-ID: <a781481a0707151614k57165061l464943233e9b32e8@mail.gmail.com>
Date: Mon, 16 Jul 2007 04:44:48 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Nigel Cunningham" <nigel@nigel.suspend2.net>
Subject: Re: Patches for REALLY TINY 386 kernels
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Jonathan Campbell" <jon@nerdgrounds.com>, linux-kernel@vger.kernel.org,
       torvalds@transmeta.com
In-Reply-To: <200707160912.55701.nigel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <469A8AED.7070207@nerdgrounds.com>
	 <200707160742.25232.nigel@nigel.suspend2.net>
	 <20070715234526.13813f8f@the-village.bc.nu>
	 <200707160912.55701.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/16/07, Nigel Cunningham <nigel@nigel.suspend2.net> wrote:
> On Monday 16 July 2007 08:45:26 Alan Cox wrote:
> > > > These patches were written against the vanilla 2.6.21.1 kernel. They
> > > > will have no effect UNLESS you make menuconfig and explicitly enable
> > > > them there.
> > >
> > > Would you please make mrproper before preparing the patch? It's harder to
> read
> > > with all the "Only in..." lines.
> >
> > A lot simpler is to feed the patch through "grep -v"
>
> Yeah. I was going for the general principle :)

Even simpler to add --exclude-from=.gitignore to diff

There's a Documentation/dontdiff file I've come across as well,
but that's horribly out-of-date and why it exists in Documentation/
I have no clue either.

Satyam
