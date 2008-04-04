Return-Path: <linux-kernel-owner+w=401wt.eu-S1755530AbYDDH2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbYDDH2R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 03:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750770AbYDDH2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 03:28:06 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:8815 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbYDDH2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 03:28:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=j3WeVgG/jmAsi72Vn5zkskeFddxmBatrfB7oVWGktRqRYTHSRsHOCNn2wpX9i9afr+u36JPX8PZcMRuqUWJ0qTyOutk8J97KdrWeJx1JWEQXnTHN5RYd4FngUQ1u4aiu6CAKHHRdA0+JD1iushPoRqYrRxhEcohQJgt1N5o1PU8=
Message-ID: <29495f1d0804040028i795a9859y585ed0ca2413816a@mail.gmail.com>
Date: Fri, 4 Apr 2008 00:28:03 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Gurudas Pai" <gurudas.pai@oracle.com>
Subject: Re: [BUG]:2.6.25-rc7 memory leak with hugepages.
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <29495f1d0804032040h56f39051lcd5f707660d3c06c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47EB4E2A.1040507@oracle.com> <20080327083849.GF15626@elte.hu>
	 <47EB75C5.20207@oracle.com>
	 <29495f1d0804032040h56f39051lcd5f707660d3c06c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/3/08, Nish Aravamudan <nish.aravamudan@gmail.com> wrote:
> On 3/27/08, Gurudas Pai <gurudas.pai@oracle.com> wrote:
>  >  Ingo Molnar wrote:
>  >  > * Gurudas Pai <gurudas.pai@oracle.com> wrote:

<snip>

>  On another note, it is odd that we're using the dynamic pool, when it
>  is initially disabled...I'll have to think about that.

What is the value in /proc/sys/vm/nr_overcommit_hugepages?

Thanks,
Nish
