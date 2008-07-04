Return-Path: <linux-kernel-owner+w=401wt.eu-S1754403AbYGDMDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbYGDMDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 08:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbYGDMDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 08:03:05 -0400
Received: from ns.firmix.at ([62.141.48.66]:3190 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764AbYGDMDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 08:03:05 -0400
Subject: Re: alphabetic ordering of MAINTAINERS
From: Bernd Petrovitsch <bernd@firmix.at>
To: Oliver Neukum <oliver@neukum.org>
Cc: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>,
       linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <200807040852.27809.oliver@neukum.org>
References: <20080704063455.GA13999@digi.com>
	 <200807040852.27809.oliver@neukum.org>
Content-Type: text/plain; charset=UTF-8
Organization: Firmix Software GmbH
Date: Fri, 04 Jul 2008 14:02:49 +0200
Message-Id: <1215172969.25343.32.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 8bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.341 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.341 required=5
X-Spam-Score: -2.341 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fre, 2008-07-04 at 08:52 +0200, Oliver Neukum wrote:
> Am Freitag 04 Juli 2008 08:34:55 schrieb Uwe Kleine-König:
[...]
> > I wanted to add an entry to MAINTAINERS and while doing it I saw that in
> > the corresponding region the alphabetic ordering is broken.  Then I
> > inteded to fix that up for a trivial patch.  Next was to check the rest
> > of the file and there are so much misorderings that it's not sensible to
> > choose the trivial path anymore as there are currently 114 entries out
> > of order[1].
> 
> What good does alphabetic ordering? You'll grep it anyway.

If two (or more) people submit patches to add a maintainer entry, is is
less likely to conflict.
And duplicates are more easily detected (without tools).

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


