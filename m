Return-Path: <linux-kernel-owner+w=401wt.eu-S1761660AbYBYWzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761660AbYBYWzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 17:55:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758787AbYBYWy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 17:54:59 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:61424 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244AbYBYWy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 17:54:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rIHQt6pM/t08kuuwL7B8v8NBmhOSWb9jXqp98dPg3Vvz3jQI/uVCDbp0vp03HD3Ukdaoi/wZ6lk14i46bBaiKSOJX1kv4IX+J0+T5zm5A9FVIjY3roOlozIpP8589eViX6IVXPHV4RAHz0HHYvgup1NUCyPgvzFjOAKPhoYz5Pc=
Message-ID: <57e2b00802251454p385e791fh6d77fab2db8d981a@mail.gmail.com>
Date: Mon, 25 Feb 2008 22:54:58 +0000
From: "Byron Bradley" <byron.bbradley@gmail.com>
To: "Martin Michlmayr" <tbm@cyrius.com>
Subject: Re: [GIT PATCH] scsi fixes for 2.6.25-rc2
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Jean Delvare" <khali@linux-fr.org>,
       "David Brownell" <david-b@pacbell.net>
In-Reply-To: <20080225223917.GX17231@deprecation.cyrius.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1203779614.3139.4.camel@localhost.localdomain>
	 <47C08134.2030205@garzik.org>
	 <alpine.LFD.1.00.0802231229320.21332@woody.linux-foundation.org>
	 <20080225223917.GX17231@deprecation.cyrius.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 10:39 PM, Martin Michlmayr <tbm@cyrius.com> wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> [2008-02-23 12:31]:
>
> > I'm personally of the opinion that a new driver that doesn't add
>  > anything but itself (ie no infrastructure changes etc) is fine. I'd
>  > rather have a new, rough driver that might work, than no driver at
>  > all, and it's not like it can cause a regression if you don't enable
>  > it.
>
>  Maybe we can still get the new S-35390A RTC driver in then.  It has
>  been acked by Jean Delvare and David Brownell.  Byron or Jean, can you
>  try to submit it again?
>
>  It's needed by the QNAP TS-109/TS-209, a NAS device for which support
>  has been added in 2.6.25-rc1.

I can send it again if needed but it's already in -mm and I assume it
would go through Andrew anyway. It would be great to get this in for
2.6.25 so if a resend is needed let me know.

Cheers,

-- 
Byron Bradley
