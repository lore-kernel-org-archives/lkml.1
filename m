Return-Path: <linux-kernel-owner+w=401wt.eu-S1753611AbXLEMXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611AbXLEMXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 07:23:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbXLEMXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 07:23:33 -0500
Received: from torres.zugschlus.de ([85.214.68.41]:38871 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbXLEMXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 07:23:32 -0500
Date: Wed, 5 Dec 2007 13:23:29 +0100
From: Marc Haber <mh+linux-kernel@zugschlus.de>
To: Ray Lee <ray@madrabbit.org>
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
Message-ID: <20071205122329.GB24685@torres.zugschlus.de>
References: <20071204114125.GA17310@torres.zugschlus.de> <20071204161811.GB15974@stusta.de> <2c0942db0712040854u17a830b9see663742b2716457@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c0942db0712040854u17a830b9see663742b2716457@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 08:54:52AM -0800, Ray Lee wrote:
> (Why hasn't anyone been cc:ing Matt on this?)

I didn't because I am not a regularly enough visitor of this mailing
list to know who is in charge of what.

> > On Tue, Dec 04, 2007 at 12:41:25PM +0100, Marc Haber wrote:
> A PRNG is clearly unacceptable.

Would a PRNG that is frequently re-seeded from true entropy be
unacceptable as well?

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Mannheim, Germany  |  lose things."    Winona Ryder | Fon: *49 621 72739834
Nordisch by Nature |  How to make an American Quilt | Fax: *49 3221 2323190
