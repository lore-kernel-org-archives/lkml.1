Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab0BELlL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 06:41:11 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:48894 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754032Ab0BELlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 06:41:09 -0500
X-Greylist: delayed 3691 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Feb 2010 06:41:09 EST
Date: Fri, 5 Feb 2010 11:39:14 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com,
       "Nikita V. Youshchenko" <yoush@cs.msu.su>, stas@lvk.cs.msu.su,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Message-ID: <20100205103914.GE9908@gundam.enneenne.com>
Mail-Followup-To: Alexander Gordeev <lasaine@lvk.cs.msu.su>,
	linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com,
	"Nikita V. Youshchenko" <yoush@cs.msu.su>, stas@lvk.cs.msu.su,
	Andrew Morton <akpm@linux-foundation.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <cover.1265228858.git.lasaine@lvk.cs.msu.su> <4cea1fe6020a188298922fac15e35e3fefed14ad.1265228858.git.lasaine@lvk.cs.msu.su>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4cea1fe6020a188298922fac15e35e3fefed14ad.1265228858.git.lasaine@lvk.cs.msu.su>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 4/5] pps: add parallel port PPS signal generator
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 03, 2010 at 11:56:50PM +0300, Alexander Gordeev wrote:
> Add PPS signal generator which utilizes STROBE pin of a parallel port to
> send PPS signals. It uses parport abstraction layer and hrtimers to
> precisely control the signal.

What this generators are used for?

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
