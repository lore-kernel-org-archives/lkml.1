Return-Path: <linux-kernel-owner+w=401wt.eu-S1755350AbYCXWvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbYCXWvJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 18:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754081AbYCXWuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 18:50:51 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:4879 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043AbYCXWuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 18:50:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ey2cfk0IbvsJW/cK2uSqwij0xfL4LJ4v+9nYLAgSa/J31/w8FM/70SvEp5/5srqOutLsVKyEv3bxUhf1U6YoWKhV8pi+rKwZbyEVd7Gc+Dqqerad3qeMCwZyGuOFZhDmtGA6lS+ui1KaH3Cjt2W89LFjYr5H8BcS67M9MBttbi8=
Message-ID: <b0943d9e0803241550k3ef0dbe8nae3b00bac34fa20@mail.gmail.com>
Date: Mon, 24 Mar 2008 22:50:49 +0000
From: "Catalin Marinas" <catalin.marinas@gmail.com>
To: "Rene Herman" <rene.herman@keyaccess.nl>
Subject: Re: [ANNOUNCE] Stacked GIT 0.14.2
Cc: "Junio C Hamano" <gitster@pobox.com>,
       "Jan Engelhardt" <jengelh@computergmbh.de>, git <git@vger.kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Josef Sipek" <jsipek@fsl.cs.sunysb.edu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <47E82BDD.9060507@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b0943d9e0803241259s5280cdc1o255a4412b3fa7bfc@mail.gmail.com>
	 <alpine.LNX.1.10.0803242113070.9368@fbirervta.pbzchgretzou.qr>
	 <47E81037.5030808@keyaccess.nl>
	 <7vlk47ua3v.fsf@gitster.siamese.dyndns.org>
	 <47E82BDD.9060507@keyaccess.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/03/2008, Rene Herman <rene.herman@keyaccess.nl> wrote:
> On 24-03-08 21:43, Junio C Hamano wrote:
>
>  > Rene Herman <rene.herman@keyaccess.nl> writes:
>  >
>  >> On 24-03-08 21:15, Jan Engelhardt wrote:
>  >>
>  >>> On Monday 2008-03-24 20:59, Catalin Marinas wrote:
>  >>>
>  >>>> Stacked GIT 0.14.2 release is available from
>  >>>> http://www.procode.org/stgit/.
>  >>>>
>  >>>> StGIT is a Python application providing similar functionality to Quilt
>  >>>> (i.e. pushing/popping patches to/from a stack) on top of GIT.
>  >>> I always wondered what the difference between stgit and guilt is.
>  >>> Does anyone have a comparison up?
>  >> And I remember some mumblings about git growing quilt-like
>  >> functionality itself. Anything on that?
>  >
>  > Not my mumbling
>
>
> Believe it was Linus. Seem to remember him saying something about possibly
>  adding a native queues-like interface not too long ago but it's proving
>  impossible to google for.

It was Linus indeed, on the linux-arch mailing list:

http://www.mail-archive.com/linux-arch@vger.kernel.org/msg05012.html

-- 
Catalin
