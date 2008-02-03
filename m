Return-Path: <linux-kernel-owner+w=401wt.eu-S933824AbYBCOfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933824AbYBCOfc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 09:35:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754377AbYBCOfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 09:35:22 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:8925 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152AbYBCOfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 09:35:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=DYV4DI3VFRzzC7KDyzqE9kKIqr55InURAKxsTiJbIZNmIlKBFn7XdWyNShs/vNY/tx3I46+7/8lNcoWijR5KFwyrsatJ3cxbX7XCMvZCSadnZHWiHZ+SuBVuSEafGysdGDBmbR0whNbC0q0XWd8oZfbULYnHgfWk5s0yTAz428I=
Message-ID: <84144f020802030635h3a9c4304n943d117e936f1c2d@mail.gmail.com>
Date: Sun, 3 Feb 2008 16:35:18 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Christer Weinigel" <christer@weinigel.se>
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Cc: "Greg KH" <greg@kroah.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080203124849.0226560f@weinigel.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080125180232.GA4613@kroah.com>
	 <20080202123710.42df1aa0@weinigel.se>
	 <20080202191930.GA19826@kroah.com>
	 <20080203124849.0226560f@weinigel.se>
X-Google-Sender-Auth: 862f5c5675f077c0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christer,

On Feb 3, 2008 1:48 PM, Christer Weinigel <christer@weinigel.se> wrote:
> Saying "use BSD" instead isn't a good answer for me since I don't know
> BSD well enough.  And personally, I want to see Linux everywhere; I
> think it's a lot better to have Linux + a proprietary driver in an
> embedded system than BSD or Windows CE.

Why are we discussing this again? The Linux kernel is distributed
under the GPLv2 and even though there are some legal gray areas
regarding derived work (think nvidia and ati binary blobs here), the
license is not friendly towards proprietary drivers at all.
Furthermore, many of the _kernel developers_ do not support
proprietary drivers, so why do you insist on using Linux for that
purpose?

Seriously, you really really want to look at the BSDs or proprietary
operating systems because they support your needs much better.

                        Pekka
