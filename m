Return-Path: <linux-kernel-owner+w=401wt.eu-S1754182AbYINJQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbYINJQ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 05:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbYINJQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 05:16:48 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:36566 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbYINJQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 05:16:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=D+l597tkN1DKaFfkqQBSRBU8ko52aiHYKTuPR7rZmB9nr5uKmCR7iu212ennXhlHY9
         6fZ6FadE5cr3GlORyHcaSxz0UXffx7hz4P9Noph+WkE+6s3esU7KozJ5y1gjWxXK65yO
         ezS2PkgL1Ji+4/8nltmQ3dwHKajxuRFZIEdvg=
Message-ID: <86802c440809140216n49f672e7x886d0d69c382f217@mail.gmail.com>
Date: Sun, 14 Sep 2008 02:16:47 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Krzysztof Helt" <krzysztof.h1@wp.pl>
Subject: Re: [PATCH] x86: better CPU identification without the CPUID
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de,
       mingo@redhat.com
In-Reply-To: <86802c440809140201q566fba43t49ec25331b774643@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080913125606.d655bdcf.krzysztof.h1@wp.pl>
	 <86802c440809132143p287edb82i6a73efbc53e6e93f@mail.gmail.com>
	 <86802c440809132255sa518aa8g51136ae21a880e2d@mail.gmail.com>
	 <20080914103018.f1d684a8.krzysztof.h1@wp.pl>
	 <86802c440809140201q566fba43t49ec25331b774643@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 14, 2008 at 2:01 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Sun, Sep 14, 2008 at 1:30 AM, Krzysztof Helt <krzysztof.h1@wp.pl> wrote:
>> On Sat, 13 Sep 2008 22:55:10 -0700
>> "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
>>
>> One wants to call c_early_init() here for Cyrix cpus- otherwise
>> the mtrr caps are not set. The correct patch here is only:

please check v2 in another mail.

YH
