Return-Path: <linux-kernel-owner+w=401wt.eu-S1758763AbZAHN3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763AbZAHN3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 08:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751072AbZAHN30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 08:29:26 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:26397 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbZAHN3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 08:29:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZlXX3D9Ev/XFYcLFqI0xhKhwn6aiCnAphNyZUPH88+vnN3Q8Cox9PlmqNo19iU6g+n
         tTmTlCZDGh94tPAGfMuxleHIpDhMW4jNN2WKMr2L3eaJKmmhaSzzq0yNpVWS1V+ivnIQ
         w3GtEn9LSxamT6/nskRukv8N1tBoFNGTIqG64=
Message-ID: <8bd0f97a0901080529j6018d5e4j66d0409bd7093425@mail.gmail.com>
Date: Thu, 8 Jan 2009 08:29:24 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Leon Woestenberg" <leon.woestenberg@gmail.com>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
Cc: "Paul Mundt" <lethal@linux-sh.org>, "Rob Landley" <rob@landley.net>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Embedded Linux mailing list" <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Sam Ravnborg" <sam@ravnborg.org>
In-Reply-To: <c384c5ea0901040223l6e53f041s9f7cdea20c9d1d8d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200901020207.30359.rob@landley.net>
	 <c384c5ea0901031454n451bc899w166bb146c96f6164@mail.gmail.com>
	 <495FEEAF.5020005@zytor.com> <200901032006.47652.rob@landley.net>
	 <20090104030619.GA21466@linux-sh.org>
	 <c384c5ea0901040223l6e53f041s9f7cdea20c9d1d8d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 4, 2009 at 05:23, Leon Woestenberg wrote:
> On Sun, Jan 4, 2009 at 4:06 AM, Paul Mundt <lethal@linux-sh.org> wrote:
>> Let's look at the rationale presented so far in this thread:
>>
>>        2 - Cross-compiling perl is hard.
>
> 2 is not hard.

i dont know where you're getting this mythical version of perl, but
anything beyond micro-perl is a pita.  and micro-perl is practically
worthless.  maybe for kernel/
-mike
