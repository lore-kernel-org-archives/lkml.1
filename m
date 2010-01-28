Return-Path: <linux-kernel-owner+w=401wt.eu-S1754314Ab0A1Apz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314Ab0A1Apz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 19:45:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902Ab0A1Apy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 19:45:54 -0500
Received: from solo.fdn.fr ([80.67.169.19]:53608 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753434Ab0A1Apx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 19:45:53 -0500
Date: Thu, 28 Jan 2010 01:45:47 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: William Hubbs <w.d.hubbs@gmail.com>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org, gregkh@suse.de,
       Chris Brannon <cmbrannon79@gmail.com>, Kirk Reiser <kirk@reisers.ca>
Subject: Re: request for assistance:  accessing ttys from kernel space
Message-ID: <20100128004547.GQ4887@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	William Hubbs <w.d.hubbs@gmail.com>, linux-kernel@vger.kernel.org,
	linux-serial@vger.kernel.org, gregkh@suse.de,
	Chris Brannon <cmbrannon79@gmail.com>,
	Kirk Reiser <kirk@reisers.ca>
References: <20100126020203.GA23551@linux1> <20100126021306.16809e71@lxorguk.ukuu.org.uk> <20100126024049.GQ21492@const.famille.thibault.fr> <20100126133958.49e660a5@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100126133958.49e660a5@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox, le Tue 26 Jan 2010 13:39:58 +0000, a écrit :
> > Is there another way to set up a line discipline from the kernel itself
> > without the need from userland intervention, even before any / is
> > mounted?
> 
> There is no fundamental reason you can't do that once the tty object
> itself exists.

I know.

> Currently there is no path for doing it in the kernel.

That's my concern :)

Thanks,
Samuel
