Return-Path: <linux-kernel-owner+w=401wt.eu-S1754755AbZCEM1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbZCEM1Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 07:27:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbZCEM1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 07:27:16 -0500
Received: from batfish.pepperfish.net ([87.237.62.180]:43333 "EHLO
	flounder.pepperfish.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752488AbZCEM1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 07:27:15 -0500
Subject: Re: [PATCH] GPIOLIB: Allow GPIOs to be named
From: Daniel Silverstone <dsilvers@simtec.co.uk>
Reply-To: dsilvers@simtec.co.uk
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090113131417.fe36d9bb.akpm@linux-foundation.org>
References: <1231504690.8511.8.camel@petitemort>
	 <20090113131417.fe36d9bb.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: Simtec Electronics
Date: Thu, 05 Mar 2009 12:27:10 +0000
Message-Id: <1236256030.21294.4.camel@petitemort>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-13 at 13:14 -0800, Andrew Morton wrote:
> > I was unable to find anything in MAINTAINERS or at the top of gpiolib.c
> > to indicate who to CC, hence sending this only to the list. Below is a
> > patch against 2150edc6c5cf00f7adb54538b9ea2a3e9cedca3f.
> gpio core is developed/maintained by David Brownell.  Who owes us a
> MAINTAINERS update ;)

David, have you had a chance to review this patch? It was also
added-to-mm on the 13th Jan as gpiolib-allow-gpios-to-be-named.patch --
I believe you were CCed on this add.

With -rc8 looming, I am anxious to know if this is acceptable for going
into the .30 merge window.

Regards,

Daniel.

-- 
Daniel Silverstone                              http://www.simtec.co.uk/
PGP mail accepted and encouraged.            Key Id: 2BC8 4016 2068 7895


