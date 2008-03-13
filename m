Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbYCMMsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbYCMMsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 08:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbYCMMsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 08:48:32 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:14293 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbYCMMsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 08:48:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=YqKOGxpifaPDGR0HAvIvcDCiwUpS2CwV1wdH5XnnSzimpUX+QhRhUkwp8CpvATE43D6F8/qISExiXBsclPtLKEEmzMHU75LKIpK8XrrNuQm0L3L9vtshUNjbPOnhgSI5IlJlrddLFX6Mt8qvgUHyxnb4Wa1pHMUzyfxwK1ksGIY=
Message-ID: <84144f020803130548o76f80fedm378f82e95c189ce2@mail.gmail.com>
Date: Thu, 13 Mar 2008 14:48:31 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: linux+glibc memory allocator, poor performance
Cc: "David Newall" <davidn@davidnewall.com>, "Mike Galbraith" <efault@gmx.de>,
       "Al Viro" <viro@zeniv.linux.org.uk>, "J.C. Pizarro" <jcpiza@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <20080313121048.5b52b28b@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <998d0e4a0803121309s125dddbao801e53e44296a4d6@mail.gmail.com>
	 <20080312211219.GL27894@ZenIV.linux.org.uk>
	 <47D8C25A.8020708@davidnewall.com>
	 <1205388732.4797.30.camel@marge.simson.net>
	 <47D8C813.6020201@davidnewall.com>
	 <84144f020803130210r1c7e8e11k7aedd3c60e7f5d0a@mail.gmail.com>
	 <20080313121048.5b52b28b@the-village.bc.nu>
X-Google-Sender-Auth: fb6861044caea7da
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Thu, Mar 13, 2008 at 2:10 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>  I think it would be far better to create linux-flame and send the hostile
>  stuff away. In a lot of cultures hostile responses or unfriendly
>  responses are taken badly. Politeness is a good thing this list needs
>  more of.

Do you honestly think we should be polite to people trolling on the
LKML? The problem with kill-filing people like J.C. Pizzarro (a known
troll on the GCC mailing list at least) is that other people will
engange in discussing these "proposals" and contribute in generating
noise anyway.
