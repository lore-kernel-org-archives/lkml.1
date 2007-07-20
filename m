Return-Path: <linux-kernel-owner+w=401wt.eu-S1759227AbXGTF0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759227AbXGTF0H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 01:26:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbXGTFZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 01:25:52 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:52127 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbXGTFZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 01:25:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Vm+hACeZuPMJq8hjR6GatPZnMfPSIEGxADXCUMN8lRzdMVm47SJ+tKTE37QuGZuPLogm5Pg5XrDRz2nij3GFMkOG5a2t6vJw1O95GbWyFa+yB8uRFzFm2lbeFQaU3E1OeP4Aocxs09ejbZOQA9Ibfcnt92GQj0CIJiMFC/TE+z8=
Message-ID: <aa4c40ff0707192225r6b5e971fy59f78a525697f864@mail.gmail.com>
Date: Thu, 19 Jul 2007 22:25:49 -0700
From: "James Lamanna" <jlamanna@gmail.com>
To: "Al Boldi" <a1426z@gawab.com>
Subject: Re: [RFH] Partion table recovery
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200707200813.03553.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707200813.03553.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/19/07, Al Boldi <a1426z@gawab.com> wrote:
> As always, a good friend of mine managed to scratch my partion table by
> cat'ing /dev/full into /dev/sda.  I was able to push him out of the way, but
> at least the first 100MB are gone.  I can probably live without the first
> partion, but there are many partitions after that, which I hope should
> easily be recoverable.
>
> I tried parted, but it's not working out for me.  Does anybody know of a
> simple partition recovery tool, that would just scan the disk for lost
> partions?

Tried gpart?
http://www.stud.uni-hannover.de/user/76201/gpart/


>
>
> Thanks!
>
> --
> Al

-- James
