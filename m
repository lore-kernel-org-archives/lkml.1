Return-Path: <linux-kernel-owner+w=401wt.eu-S1755937AbZJPHSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937AbZJPHSN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 03:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755611AbZJPHSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 03:18:12 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:43458 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427AbZJPHSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 03:18:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=MLTCBPEorG1c5YpgymEyg+j3UB66BoyNXDkKYGOjswH/+L6BCrR/BiQsfC1vCsycAZ
         v81McY6Ci3B3Qi5icK6AUB4SdVLKzfF8yxtjVxDWtSa+l/qIsis63TlMjoR42QW0Wwhp
         4MBxHzi9o0I7d4OlFZX2G66DyNyaYmslupgog=
MIME-Version: 1.0
In-Reply-To: <4AD7F633.4070507@agilent.com>
References: <4AD5D476.6010103@agilent.com>
	 <200910141653.03611.elendil@planet.nl> <4AD655C0.2030202@agilent.com>
	 <200910150211.43532.elendil@planet.nl> <4AD7F633.4070507@agilent.com>
Date: Fri, 16 Oct 2009 10:16:23 +0300
X-Google-Sender-Auth: 0a54e56e47d945d3
Message-ID: <84144f020910160016r125e2cbrf2fae48f168db79c@mail.gmail.com>
Subject: Re: fs/pipe.c null pointer dereference
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Earl Chew <earl_chew@agilent.com>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Earl,

On Fri, Oct 16, 2009 at 7:27 AM, Earl Chew <earl_chew@agilent.com> wrote:
> Frans Pop wrote:
>>
>> Good luck with the hunt.
>
> I've logged a defect:
>
> http://bugzilla.kernel.org/show_bug.cgi?id=14416
>
> which includes a proposed fix and script to reproduce.

Can you please send the patch to LKML so your fix doesn't get lost in
the noise? See Documentation/SubmittingPatches for details.

                        Pekka
