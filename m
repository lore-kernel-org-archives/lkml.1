Return-Path: <linux-kernel-owner+w=401wt.eu-S932229AbZHGSQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229AbZHGSQJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 14:16:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754851AbZHGSQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 14:16:08 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54902 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279AbZHGSQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 14:16:07 -0400
Date: Fri, 7 Aug 2009 14:00:33 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Frans Pop <elendil@planet.nl>, Chris Clayton <chris2553@googlemail.com>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: ath5k - strange regulatory domain change
Message-ID: <20090807180033.GH7545@tuxdriver.com>
References: <c6b1100b0908070350t3101030bs4b3d2e7485ad9aee@mail.gmail.com> <20090807151304.GE7545@tuxdriver.com> <43e72e890908071013w28644e70h5323e19d19da33a2@mail.gmail.com> <200908071939.49627.elendil@planet.nl> <43e72e890908071051w1f306349rfab32de80759006e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43e72e890908071051w1f306349rfab32de80759006e@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 10:51:17AM -0700, Luis R. Rodriguez wrote:
> On Fri, Aug 7, 2009 at 10:39 AM, Frans Pop<elendil@planet.nl> wrote:

> > Probably the simplest option would be to just display some identification
> > of the domain group itself and point users to documentation which
> > explains what countries fall under what groups. That would at least avoid
> > the confusion caused by randomly picking a matching country.
> > Variation could be to display the country if the group only contains one
> > country, but that could also be considered an inconsistent user
> > interface.
> 
> Or maybe see if the currently set regulatory domain matches an alpha2
> in the group, if so then just display the same alpha2. Will take a
> look.

That makes sense to me...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
