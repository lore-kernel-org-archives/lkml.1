Return-Path: <linux-kernel-owner+w=401wt.eu-S1759399AbYAGNMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759399AbYAGNMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 08:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756335AbYAGNMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 08:12:32 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:32599 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759316AbYAGNMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 08:12:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ptl/HKKi2vUBbQGtJr3/GrKvAdam4YxlMWH3ZgzQM7Do6J691RfayFAopzMuU8+u3qVUMoNJXh00f41rpo/PuTbwgvxUMFreMFuRxW9yY1tYu4QfuZOwZcRYPr/3t9AaD0pzVCOBEnVqrwcS10v39GbY524pqZTJb6AvurM02jg=
Message-ID: <84144f020801070512i93296d9i7c72242992be03f1@mail.gmail.com>
Date: Mon, 7 Jan 2008 15:12:30 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Michal Simek" <simekm2@fel.cvut.cz>
Subject: Re: New linux arch
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <47822272.9090503@fel.cvut.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47820D24.3060800@fel.cvut.cz>
	 <84144f020801070447t68808bcdq64bfc949c7732462@mail.gmail.com>
	 <47822272.9090503@fel.cvut.cz>
X-Google-Sender-Auth: b46cb97b06bd96d5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On Jan 7, 2008 3:00 PM, Michal Simek <simekm2@fel.cvut.cz> wrote:
> > You can have as many maintainers as you want but you probably don't
> > want to make it too many. There aren't any "official" responsibilities
> > as a maintainer, it really depends on how much time and effort you're
> > willing to put in.
>
> OK. Don't you have idea how many linux kernels are maintained by more
> people?

Well, just look up some mainstream architectures in MAINTAINERS. The
x86 architecture, for example, has three but the point here is that
you probably don't want to end up with ten individual maintainers (how
are you going to coordinate the work?) whereas more than one is
definitely okay.

If you have a lot of people maintaining your port, then just create a
mailing list and put that in MAINTAINERS with only few "top
maintainers" listed by their individual email to make life easy for
patch submitters.

                        Pekka
