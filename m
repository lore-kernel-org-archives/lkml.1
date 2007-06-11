Return-Path: <linux-kernel-owner+w=401wt.eu-S1755687AbXFKRi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687AbXFKRi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 13:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbXFKRiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 13:38:14 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:36413 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbXFKRiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 13:38:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VKKdG4hbsQzSEIYWzTpm5+/VLpRNpshrmn4fRauzKz5GFfwkrL1XElz2PLzBrYD1SCYeJKircVzgBDWcY7QHyJQ5sdYn01ggEvvgLbekRPk19XoaljrKRUfWTRQDAnMdA/znnboTBNVCY1AvdTQjyRkhHJUa8MuWnZWg3ofqmoI=
Message-ID: <12c511ca0706111038j37e188b6n2677b1789d14de23@mail.gmail.com>
Date: Mon, 11 Jun 2007 10:38:10 -0700
From: "Tony Luck" <tony.luck@gmail.com>
To: "Matt Mackall" <mpm@selenic.com>
Subject: Re: [RFD] Documentation/HOWTO translated into Japanese
Cc: "Greg KH" <gregkh@suse.de>, "Matthias Schniedermeyer" <ms@citd.de>,
       "Jesper Juhl" <jesper.juhl@gmail.com>,
       "Tsugikazu Shibata" <tshibata@ab.jp.nec.com>,
       linux-kernel@vger.kernel.org, m-ikeda@ds.jp.nec.com
In-Reply-To: <20070611134326.GH11166@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070610.204845.115909592.tshibata@ab.jp.nec.com>
	 <9a8748490706100524o2dff1954ja7406f9303d8499f@mail.gmail.com>
	 <20070610162221.GA12830@suse.de> <466C3B64.4070806@citd.de>
	 <20070611060759.GB914@suse.de> <20070611134326.GH11166@waste.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I'd rather have a single file, marked "Japanese" (in Japanese), that
> had pointers to current translations. These will always be at least as
> current as whatever we have in the tree, if not more so. Especially
> when someone is trying to figure out how to work based on the year-old
> kernel their embedded vendor gave them.

Knowing whether a translation is current or not would be useful ... perhaps
the translated files could include the GIT blob SHA1 of the version they
were translated from (and some human readable version string too :-)
This would allow someone reading the documentation to know whether
is really was current.  If it isn't, it provides an easy path to see what
changed in the source document since the translation was made. This
same diff should lighten the load for people maintaining the translation.

-Tony
