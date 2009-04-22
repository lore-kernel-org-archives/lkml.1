Return-Path: <linux-kernel-owner+w=401wt.eu-S1756113AbZDVVis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbZDVVis (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 17:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754454AbZDVVih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 17:38:37 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:46383 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbZDVVig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 17:38:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=BzKiGSfUuf5FQzdMjFH60VjC363ToWFiY4h8t0wTFEFvXKHsS/OM76HEPkjJeZA71f
         Zim5USruh8a35qJ26aGRkO2fGpwxRhQ+WhQlEvV7p3zuLrnEF31V6UmlUf8zinke6L2c
         wFWdJVkYqE5Rb9cwdlIJ5o+g9KMCZBy4D+e68=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Joe Perches <joe@perches.com>
Subject: Re: [git pull] IDE fixes
Date: Wed, 22 Apr 2009 23:41:37 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090403; KDE/4.2.1; i686; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200904222048.15556.bzolnier@gmail.com> <200904222143.47220.bzolnier@gmail.com> <1240430103.21848.101.camel@localhost>
In-Reply-To: <1240430103.21848.101.camel@localhost>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904222341.37846.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 April 2009 21:55:03 Joe Perches wrote:
> On Wed, 2009-04-22 at 21:43 +0200, Bartlomiej Zolnierkiewicz wrote:
> > IMO we should just remove extra commas and add some whitespaces.
> 
> Your choice.
> Ignore, reject, accept, improve, fine by me.
> 
> > I have also more general (process oriented) comment:
> > 
> > All patches have been posted to linux-kernel or linux-ide for review before
> > and it is _much_ more efficient to raise issues (including CodingStyle ones)
> > during "review phase" instead of during "push to Linus" phase.
> 
> Maybe for you, but I'm an intermittent
> and random reader.

For everybody involved in the process -- this includes you.

I'm not the original author of many patches so I simply cannot be
correcting every single issue because:

a) it is physically impossible

b) it doesn't really educate people

Thanks,
Bart
