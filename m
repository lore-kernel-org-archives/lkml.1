Return-Path: <linux-kernel-owner+w=401wt.eu-S1761271AbYBEV2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761271AbYBEV2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 16:28:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758868AbYBEV15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 16:27:57 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:4960 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758792AbYBEV14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 16:27:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eV8R1DqhL8TuHx142PxzhXRbMgcW5Q4KSGF2xR3nE5WlKsaWBNqiEaM+f+rKUirqsjIJ7ptDH9cAXpBPTItvA0JnPS0NfrDm7gbzWYZCEnnJ5R52HIRhqKZO6FsuIJdNOQ9aEK13vUJyfIcht0+waetfIgSryOcRxWwFM1nli0s=
Message-ID: <9a8748490802051327q38f63c41ie5ea1f923eb2c08d@mail.gmail.com>
Date: Tue, 5 Feb 2008 22:27:53 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: [linux-pm] Re: Small pm documentation cleanups
Cc: "Nigel Cunningham" <nigel@nigel.suspend2.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Len Brown" <len.brown@intel.com>,
       "Linux-pm mailing list" <linux-pm@lists.osdl.org>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Trivial patch monkey" <trivial@kernel.org>
In-Reply-To: <20080205182712.GA9483@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080204234700.GA1912@elf.ucw.cz> <200802050224.51039.rjw@sisk.pl>
	 <47A7F581.8060300@nigel.suspend2.net>
	 <20080205182712.GA9483@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2008, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
> >> On Tuesday, 5 of February 2008, Pavel Machek wrote:
> >>> Small documentation fixes/additions that accumulated in my tree.
> >>>
> >>> Signed-off-by: Pavel Machek <pavel@suse.cz>
> >>
> >> Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
> >>
> ...
...
>
> Thanks for comments, I applied them.
>
> Small documentation fixes/additions that accumulated in my tree.
>
> Len, please pick this up, thanks.
>                                                                         Pavel
>
>
> Signed-off-by: Pavel Machek <pavel@suse.cz>
> Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
>

I've put this on my watch list for the trivial tree.
So, if it doesn't get merged elsewhere I'll take care of pushing it
again during the 2.6.26 merge window (and beyond).

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
