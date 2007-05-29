Return-Path: <linux-kernel-owner+w=401wt.eu-S1759315AbXE2F6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759315AbXE2F6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 01:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbXE2F6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 01:58:44 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:40527 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbXE2F6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 01:58:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sfSAx20nb5r6l72Y0fSCIutYyNFrCSaw1+IpwmzxtdNzVABBFrB2Gr/2yN8AYTuEoa5KTRhC+tUsnLr/hL9YMVuCjWAAqFL+Ox7yQuGFTUPpl+sOMBfGkoLc5VwgmII2GHnqNSoXsMaXTGHhRTPLOHnvpOgThpW7JaS5+6M0nkU=
Message-ID: <4cefeab80705282258p570c649aja5a60b82f63c2440@mail.gmail.com>
Date: Tue, 29 May 2007 11:28:43 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Bret Towe" <magnade@gmail.com>
Subject: Re: [RFC] LZO de/compression support - take 6
Cc: lkml <linux-kernel@vger.kernel.org>, linux-mm-cc@laptop.org,
       linuxcompressed-devel@lists.sourceforge.net,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Daniel Hazelton" <dhazelton@enter.net>,
       "Richard Purdie" <richard@openedhand.com>,
       "Satyam Sharma" <satyam.sharma@gmail.com>
In-Reply-To: <dda83e780705281553s67ace88at60f6ab28b198a832@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com>
	 <dda83e780705281553s67ace88at60f6ab28b198a832@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/29/07, Bret Towe <magnade@gmail.com> wrote:
>
> tested this on ppc and its still good

> is there any reason to bother with a test on amd64?
> if there is I might be able to get to it tonight
>
Yes, this test is desired on 'take 6'
(In future I will append version to patch bz2)

Thanks,
Nitin
