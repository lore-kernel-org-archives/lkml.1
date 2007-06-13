Return-Path: <linux-kernel-owner+w=401wt.eu-S1758281AbXFMLnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758281AbXFMLnn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 07:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757611AbXFMLne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 07:43:34 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:50372 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757581AbXFMLnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 07:43:33 -0400
Date: Wed, 13 Jun 2007 13:43:26 +0200
From: Pavel Machek <pavel@ucw.cz>
To: James Ketrenos <jketreno@linux.intel.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
       Zhu Yi <yi.zhu@intel.com>
Subject: Re: ipw3945 driver in recent -mm kernels
Message-ID: <20070613114326.GA1973@elf.ucw.cz>
References: <20070609192703.GA6410@elf.ucw.cz> <20070609215712.GA13678@elf.ucw.cz> <466DA14D.6080309@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466DA14D.6080309@linux.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Thanks for help. I was finaly able to make it to work. It is quite
sensitive to order of commands... and still does not light the led up
on x60, but it works. (Part of problem was that it tried to associate
in 5GHz range, and another part was my error in configuring IP
addresses).

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
