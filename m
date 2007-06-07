Return-Path: <linux-kernel-owner+w=401wt.eu-S1757204AbXFGNKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204AbXFGNKR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 09:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661AbXFGNKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 09:10:05 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:11059 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbXFGNKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 09:10:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=p0YtdnJ6WgVOhqaQ5aQQ36iS7m6kBdy/3U2KpPvZPLEAMVrgbqLL/sGSoPQZL8Ob/mOJ2bA8Elx0W5xRniIxRa5fEluuSR428WXC4uRnsCxw+53yah6uRtL9mP7nKfz2MqVIFj8wK1gNZ6H6tsYU1zt3PV6wgdl85y6Mb12GCyI=
Message-ID: <a790ea7a0706070610y4693da95he77e576dc05d1f17@mail.gmail.com>
Date: Thu, 7 Jun 2007 15:10:02 +0200
From: "Antonio Mignolli" <antoniomignolli@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Fwd: lid switch hangs notebook
In-Reply-To: <a790ea7a0706070536v60be358cn277b4be4ca9deb1f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a790ea7a0703120753i232ace2bg7272fa479b821e32@mail.gmail.com>
	 <20070315110606.741c2dc4.akpm@linux-foundation.org>
	 <200704131553.54787.bjorn.helgaas@hp.com>
	 <a790ea7a0706040357g799e8756ue758e95d5b460307@mail.gmail.com>
	 <20070607104208.GA8245@ucw.cz>
	 <a790ea7a0706070536v60be358cn277b4be4ca9deb1f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I forgot the forwarding to the mailing list...


---------- Forwarded message ----------
From: Antonio Mignolli <antoniomignolli@gmail.com>
Date: Jun 7, 2007 2:36 PM
Subject: Re: lid switch hangs notebook
To: Pavel Machek <pavel@ucw.cz>


Hi, thanks for all your responses.

Never enabled APM,
and sure, no hangs in grub.
As I said, the problem started from kernel 2.6.19
(never tried 2.6.18).
I've only tried Slackware, so far, in case it's not a kernel-related
issue, I will try something else.
Bye.

On 6/7/07, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
> > The problem reported below has not been solved,
> > I tried with the last stable kernel 2.6.21.3.
> >
> > But it seems not to be an ACPI issue,
> > I removed ACPI support from the kernel,
> > and still have the problem.
> > What else could be?
>
> Does it hang the box if you close/open the lid on grub prompt?
>
> Also try disabling apm.
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>
