Return-Path: <linux-kernel-owner+w=401wt.eu-S1752789AbYK1PsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbYK1PsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 10:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbYK1PsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 10:48:08 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:20421 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbYK1PsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 10:48:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=i3sCcDbvE1HsC6D7WdooEeZ9DNRnQ1b+7ZVFIfRIRBeuSjFk8B0jNlqHxV2+5JLPt5
         HxrN6lDT4LyFZn7h/EuExG0P3CzoEfR47uZn9wwcLUd9vPs3So7uBvW9RyYN88nc1sgX
         cXcVMjE+Mir7C8uhv6dRfqKPo4a3uUqoF5epw=
Message-ID: <412bdbff0811280748g9a6a37fg1819a6b32e271b8d@mail.gmail.com>
Date: Fri, 28 Nov 2008 10:48:03 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 1/7] Adding empia base driver
Cc: "Markus Rechberger" <mrechberger@gmail.com>,
       "Aidan Thornton" <makosoft@googlemail.com>, "Greg KH" <greg@kroah.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <84144f020811270133r179828eat69b24c067c55447@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9def9db0810221414w5348acf3re31a033ea7179462@mail.gmail.com>
	 <20081022220903.GA15278@kroah.com>
	 <d9def9db0810221524m738b838bs681c0b9159531c64@mail.gmail.com>
	 <c8b4dbe10811261112w6cbbec73mb468870f206d9f97@mail.gmail.com>
	 <d9def9db0811262025v5d1b0df4h3855cb6023be2cf7@mail.gmail.com>
	 <84144f020811270133r179828eat69b24c067c55447@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2008 at 4:33 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> On Thu, Nov 27, 2008 at 6:25 AM, Markus Rechberger
> <mrechberger@gmail.com> wrote:
>> I simply don't have the time for those games anymore, and those people here who have personal
>> issues with me and/or my work don't pay my monthly bills, neither do they have any clue how that
>> driver is used with some systems of certain customers. I constantly deliver full solutions, and not
>> driver code only. Neither am I limited to Linux only.
>
> Again, it's not personal, it's the way we do things here. But you
> should already know that by now so whatever.
>
> What puzzles me the most here is why isn't Empia simply providing
> datasheets to other developers as well. I mean, even the GPU and
> wireless vendors know how to play well with the community now, so
> what's the problem? Being locked to just one developer who's unwilling
> to cooperate doesn't sound like a winning strategy to me.
>
> Greg, is there any reason we don't have Markus' out-of-tree driver
> listed here, btw:
>
>  http://www.linuxdriverproject.org/twiki/bin/view/Main/OutOfTreeDrivers
>
> Maybe there are people in the "Linux Driver Project" that could be
> interested in working on this but simply don't know about it?
>
>                               Pekka
> --

Hello Pekka,

In Empia's defense, they actually have recently provided the
datasheets to others under NDA, such as myself.  This is one of the
reasons the in-kernel em28xx driver has improved significantly in the
last month (including new support for the em2874 and fixes to
em2860/em2880 support).

The in-kernel driver will continue to improve, device support will
continue to increase as I work with the people who have devices that
people care about.

Markus has made it very clear that he does not want any of his code
merged into the existing in-kernel em28xx driver.  Depsite the fact
that the license specifically allows doing exactly that, I have made
an effort to respect his feelings in this manner.

Regards,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
