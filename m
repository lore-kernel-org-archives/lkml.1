Return-Path: <linux-kernel-owner+w=401wt.eu-S1755550AbYGDMGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbYGDMGU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 08:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998AbYGDMGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 08:06:08 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:35590 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbYGDMGH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 08:06:07 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Bernd Petrovitsch <bernd@firmix.at>
Subject: Re: alphabetic ordering of MAINTAINERS
Date: Fri, 4 Jul 2008 14:06:41 +0200
User-Agent: KMail/1.9.9
Cc: "Uwe =?utf-8?q?Kleine-K=C3=B6nig?=" <Uwe.Kleine-Koenig@digi.com>,
       linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
References: <20080704063455.GA13999@digi.com> <200807040852.27809.oliver@neukum.org> <1215172969.25343.32.camel@tara.firmix.at>
In-Reply-To: <1215172969.25343.32.camel@tara.firmix.at>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200807041406.41801.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 04 Juli 2008 14:02:49 schrieb Bernd Petrovitsch:
> On Fre, 2008-07-04 at 08:52 +0200, Oliver Neukum wrote:
> > Am Freitag 04 Juli 2008 08:34:55 schrieb Uwe Kleine-König:
> [...]
> > > I wanted to add an entry to MAINTAINERS and while doing it I saw that in
> > > the corresponding region the alphabetic ordering is broken.  Then I
> > > inteded to fix that up for a trivial patch.  Next was to check the rest
> > > of the file and there are so much misorderings that it's not sensible to
> > > choose the trivial path anymore as there are currently 114 entries out
> > > of order[1].
> > 
> > What good does alphabetic ordering? You'll grep it anyway.
> 
> If two (or more) people submit patches to add a maintainer entry, is is
> less likely to conflict.
> And duplicates are more easily detected (without tools).

If you can come up with a rule for naming a driver, yes.

	Regards
		Oliver
