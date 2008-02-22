Return-Path: <linux-kernel-owner+w=401wt.eu-S1762058AbYBVRpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762058AbYBVRpT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 12:45:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754017AbYBVRpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 12:45:01 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:47366 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756063AbYBVRo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 12:44:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=aoXovYYVUYQkzLNhofxu3lGd0+VpqeGdgMK54QLdpe5TMFTSQ9HTeMMlpK4/HqMuBDHgpPlesShRvhRu9zcpLmna+yPr4S6r0OCsUxdx5MkmPrSY6WmWD5c9WQyL4cdw93xMd+iV5Yv5oZ7hjVYnSA3b1OOMni3eHWddIud1qh8=
Message-ID: <47BF09DD.7090301@gmail.com>
Date: Fri, 22 Feb 2008 18:43:57 +0100
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Sripathi Kodi <sripathik@in.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, vinay@linux.vnet.ibm.com,
       drpeper@redhat.com
Subject: Re: [PATCH] RUSAGE_THREAD
References: <200802051125.50423.sripathik@in.ibm.com>
In-Reply-To: <200802051125.50423.sripathik@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Sripathi Kodi wrote:
> Hi Andrew,
> 
> This adds the RUSAGE_THREAD option for the getrusage system call.
> This is essentially Roland's patch from http://lkml.org/lkml/2008/1/18/589, 
> but the line about RUSAGE_LWP line has been removed, as suggested
> by Ulrich and Christoph.
> 
> Thanks,
> Sripathi.
> 
> This adds the RUSAGE_THREAD option for the getrusage system call.

Sripathi,

Could you write some small piece of text for the getrusage.2 man page that
describes the intended behavior of RUSAGE_THREAD?

Thanks,

Michael

-- 
Michael Kerrisk
Maintainer of the Linux man-pages project
http://www.kernel.org/doc/man-pages/
Want to report a man-pages bug?  Look here:
http://www.kernel.org/doc/man-pages/reporting_bugs.html


