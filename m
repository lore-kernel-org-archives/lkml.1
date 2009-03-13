Return-Path: <linux-kernel-owner+w=401wt.eu-S1757304AbZCMJoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbZCMJoK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 05:44:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbZCMJn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 05:43:56 -0400
Received: from batfish.pepperfish.net ([87.237.62.180]:36470 "EHLO
	flounder.pepperfish.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751517AbZCMJn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 05:43:56 -0400
Subject: Re: [PATCH] GPIOLIB: Allow GPIOs to be named
From: Daniel Silverstone <dsilvers@simtec.co.uk>
Reply-To: dsilvers@simtec.co.uk
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>
In-Reply-To: <1236256030.21294.4.camel@petitemort>
References: <1231504690.8511.8.camel@petitemort>
	 <20090113131417.fe36d9bb.akpm@linux-foundation.org>
	 <1236256030.21294.4.camel@petitemort>
Content-Type: text/plain
Organization: Simtec Electronics
Date: Fri, 13 Mar 2009 09:43:49 +0000
Message-Id: <1236937429.1218.2.camel@petitemort>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-05 at 12:27 +0000, Daniel Silverstone wrote:
> > > I was unable to find anything in MAINTAINERS or at the top of gpiolib.c
> > > to indicate who to CC, hence sending this only to the list. Below is a
> > > patch against 2150edc6c5cf00f7adb54538b9ea2a3e9cedca3f.
> > gpio core is developed/maintained by David Brownell.  Who owes us a
> > MAINTAINERS update ;)
> David, have you had a chance to review this patch? It was also
> added-to-mm on the 13th Jan as gpiolib-allow-gpios-to-be-named.patch --
> I believe you were CCed on this add.
> With -rc8 looming, I am anxious to know if this is acceptable for going
> into the .30 merge window.

Andrew,

with -rc8 out, and David apparently MIA on this topic, is now an
appropriate time for me to ask that you queue this up for the .30 merge
window, or is that something you can't really do?

Regards,

Daniel.

-- 
Daniel Silverstone                              http://www.simtec.co.uk/
PGP mail accepted and encouraged.            Key Id: 2BC8 4016 2068 7895


