Return-Path: <linux-kernel-owner+w=401wt.eu-S1753996AbXDOVuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbXDOVuG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 17:50:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753992AbXDOVuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 17:50:06 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:3512 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996AbXDOVuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 17:50:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JOy8Tz3AIegRqYqM9b7v935Wd+bWTcm0xrhwoaQPmRqhA6haesArZMC2q8g2CZV4bJ3wmgwXWic8Ozz0wPBAoQCje32inQ2Kb2C8hpaqCsGOgfrwaLDHGCXHRDEZr6AYSVgjxhgxngHGHenKxUdSQcxwlHXo0g6Iy8wPH3LejuE=
Message-ID: <9a8748490704151450i251b8b1av8439bc275e982866@mail.gmail.com>
Date: Sun, 15 Apr 2007 23:50:03 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: so what *is* obsolete and removable?
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Adrian Bunk" <bunk@stusta.de>
In-Reply-To: <Pine.LNX.4.64.0704151647200.29357@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0704151647200.29357@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/04/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
>
>   in a recent posting, ian anderson suggested that, before kernel
> features are removed, they should spend a reasonable amount of time in
> the feature removal file to give everyone fair warning.  if that's the
> case, then there are a *bunch* of things that should perhaps be added
> to that file real soon now just to start the clock ticking.
>
[snip]
> ./sound/oss/Kconfig:    bool "Obsolete OSS drivers"
> ./sound/oss/Kconfig:      This option enables support for obsolete OSS drivers that
>
>   clearly, that was a fairly brainless search, but it still reveals a
> pile of stuff that's "obsolete" (whatever that means in the context in
> which it's used).  so what's really obsolete?
>
IIRC Adrian Bunk is handling the removal of obsolete OSS drivers and
doing a nice job at it. Dunno about the rest of the stuff.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
