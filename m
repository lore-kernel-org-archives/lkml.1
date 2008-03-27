Return-Path: <linux-kernel-owner+w=401wt.eu-S1760091AbYC0OoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760091AbYC0OoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 10:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757257AbYC0OoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 10:44:00 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:19606 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196AbYC0On7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 10:43:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=WFOZhCeg2WXbqF96GDRz3xzaGka19/15J6p4emnbvBnPIGYrIFbqGUmTEqyx9Td3XHKzhXRRqsbcA2Vd4+BiAW1/xLHShHgPp+iKYb7w8QFwN7CL2liWoErrzvpFP1jhTobpzVq5YovqfTRIdoYZM4BV9OG+R5bctC4j+DBx/OU=
Message-ID: <2c0942db0803270743q19ada193n386f55eb2272aeda@mail.gmail.com>
Date: Thu, 27 Mar 2008 07:43:48 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Romano Giannetti" <romanol@upcomillas.es>
Subject: Re: 2.6.25-rc6-git6: Reported regressions from 2.6.24
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       "Adrian Bunk" <bunk@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Natalie Protasevich" <protasnb@gmail.com>
In-Reply-To: <1206613112.26152.2.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803220259.48534.rjw@sisk.pl>
	 <2c0942db0803260930y741dfe81r114bd18b35e0bbe5@mail.gmail.com>
	 <1206613112.26152.2.camel@localhost>
X-Google-Sender-Auth: de50c7cfdee673fe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 3:18 AM, Romano Giannetti <romanol@upcomillas.es> wrote:
>  On Wed, 2008-03-26 at 09:30 -0700, Ray Lee wrote:
> > Though the original reporter hasn't replied, Christoph Hellwig hit the
>  > same issue and was able to confirm that installing the dbus-x11
>
>  Yes, I have answered in the bugzilla that installing dbus-x11
>  fixes/hides the problem for me:
>  http://bugzilla.kernel.org/show_bug.cgi?id=10041#c15
>
>  Should I have also posted it here? If so, sorry (but in this case, why
>  not set up auto-forwarding to l-k of the bugzilla entries related to the
>  Rafael regression list?)

No, you did fine, it was my mistake; I forgot to check bugzilla before
posting. Thanks for testing.
