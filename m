Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbZICTnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbZICTnF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 15:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755029AbZICTnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 15:43:04 -0400
Received: from kroah.org ([198.145.64.141]:39082 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888AbZICTnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 15:43:03 -0400
Date: Thu, 3 Sep 2009 12:41:21 -0700
From: Greg KH <greg@kroah.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Christian Lamparter <chunkeey@web.de>,
       "John W. Linville" <linville@tuxdriver.com>,
       Stephen Chen <Stephen.Chen@atheros.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: Staging tree status for the .32 kernel merge
Message-ID: <20090903194121.GA4953@kroah.com>
References: <20090903041429.GA29875@kroah.com>
 <1251967786.3336.19.camel@johannes.local>
 <43e72e890909031235t17543020leb3d19b17d955d01@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <43e72e890909031235t17543020leb3d19b17d955d01@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 03, 2009 at 12:35:11PM -0700, Luis R. Rodriguez wrote:
> >>       - otus.  This is sitting here until a "real" wireless driver
> >>         will be merged through the wireless tree.  Hopefully that
> >>         happens soon.
> >
> > ar9170 has been in for a while now, it's just not quite at feature
> > parity yet -- however that also means otus will get no work whatsoever
> > from any of the wireless folks. Draw your own conclusions. Personally, I
> > would drop it and let the users figure out whether they can live with
> > ar9170 or need to support work on it.
> 
> Greg, as Johannes noted otus has lacked focus as Johannes whipped out
> a port for it in a few weeks and then Christian gave it some final
> love taps for inclusion, we just still use otus as just a source of
> documentation for any yet missing feature, but for that I guess I can
> just refer people to my git tree. Chris would know better where we're
> at as far as feature-parity is concerned though so I'll leave it up to
> him to judge whether or not having otus gets some users anything
> ar9170 doesn't yet have.

Ok, as I've said before, just let me know when you want the otus driver
removed from the tree and I'll be glad to do so.

thanks,

greg k-h
