Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481Ab0AZC1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab0AZC1O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 21:27:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164Ab0AZC1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 21:27:12 -0500
Received: from solo.fdn.fr ([80.67.169.19]:37797 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122Ab0AZC1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 21:27:11 -0500
Date: Tue, 26 Jan 2010 03:27:05 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: William Hubbs <w.d.hubbs@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org, gregkh@suse.de,
       Chris Brannon <cmbrannon79@gmail.com>, Kirk Reiser <kirk@reisers.ca>
Subject: Re: request for assistance:  accessing ttys from kernel space
Message-ID: <20100126022705.GP21492@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	William Hubbs <w.d.hubbs@gmail.com>, linux-kernel@vger.kernel.org,
	linux-serial@vger.kernel.org, gregkh@suse.de,
	Chris Brannon <cmbrannon79@gmail.com>,
	Kirk Reiser <kirk@reisers.ca>
References: <20100126020203.GA23551@linux1>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100126020203.GA23551@linux1>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

William Hubbs, le Mon 25 Jan 2010 20:02:03 -0600, a écrit :
> What I would like to discuss is how we can access ttys from kernel
> space.  If we could do this, it would definitely make things much easier
> for us in speakup.

The same would be useful for better kernel-level braille device support.

Samuel
