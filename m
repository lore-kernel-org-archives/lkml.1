Return-Path: <linux-kernel-owner+w=401wt.eu-S1760673AbXEJQs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760673AbXEJQs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 12:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756263AbXEJQsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 12:48:50 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:33282 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307AbXEJQss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 12:48:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bMXtZor2WnkPefOJl9RfDzoMrsREeJvzGr87csorNCYGcqYCAopjKhm+AvmEUyzeTGeqD1Jks8dLw2RrWdJYQigEmhVKkvXhOotfDoKyotsoVsSUww4WrsuVLO4Xkhs1uf3PsCnAfxlN0u1BDwOt4r8ni8Z42UBVzbvQWzWkJ+U=
Message-ID: <a781481a0705100948x71279953ja4dc1903adda177@mail.gmail.com>
Date: Thu, 10 May 2007 22:18:46 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Xavier Bestel" <xavier.bestel@free.fr>
Subject: Re: Please revert 5b479c91da90eef605f851508744bfe8269591a0 (md partition rescan)
Cc: "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Neil Brown" <neilb@suse.de>,
       "Andrew Morton" <akpm@linux-foundation.org>, linux-raid@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "David Greaves" <david@dgreaves.com>,
       "Doug Ledford" <dledford@redhat.com>
In-Reply-To: <1178809197.7699.4.camel@frg-rhel40-em64t-04>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <17986.26930.952993.510918@notabene.brown>
	 <alpine.LFD.0.98.0705091848370.4062@woody.linux-foundation.org>
	 <Pine.LNX.4.61.0705101650340.24536@yvahk01.tjqt.qr>
	 <1178809197.7699.4.camel@frg-rhel40-em64t-04>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/10/07, Xavier Bestel <xavier.bestel@free.fr> wrote:
> On Thu, 2007-05-10 at 16:51 +0200, Jan Engelhardt wrote:
> > >(But Andrew never saw your email, I suspect: "akpm@suse.de" is
> > probably
> > >some strange mixup of Andrew Morton and Andi Kleen in your mind ;)
> >
> > What do the letters kp stand for?

Heh ... I've always wanted to know that myself. It's funny, no one
seems to have asked that on lkml during all these years (at least none
that a Google search would throw up).

> "Keep Patching" ?

Unlikely. "akpm" seems to be a pre-Linux-kernel nick.
