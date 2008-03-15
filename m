Return-Path: <linux-kernel-owner+w=401wt.eu-S1752696AbYCOFc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbYCOFc3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 01:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbYCOFcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 01:32:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55461 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbYCOFcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 01:32:19 -0400
Date: Fri, 14 Mar 2008 22:30:37 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Joel K. Greene" <joel.greene@catapult.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Timer interrupt stops, causes soft lockup
Message-ID: <20080314223037.32fc5d7a@laptopd505.fenrus.org>
In-Reply-To: <1205515282.29658.111.camel@linuxdt036.nc.catapult.com>
References: <1204653133.718.14.camel@linuxdt036.nc.catapult.com>
	<47CD634E.2828.00B3.0@novell.com>
	<1204722318.6578.12.camel@linuxdt036.nc.catapult.com>
	<47CE45D8.2828.00B3.0@novell.com>
	<1204728175.6578.23.camel@linuxdt036.nc.catapult.com>
	<47D3DC53.2828.00B3.0@novell.com>
	<1205152374.18463.17.camel@linuxdt036.nc.catapult.com>
	<1205235450.18463.45.camel@linuxdt036.nc.catapult.com>
	<47D6423D.1E6F.00AA.0@novell.com>
	<1205255048.18463.60.camel@linuxdt036.nc.catapult.com>
	<1205260328.18463.67.camel@linuxdt036.nc.catapult.com>
	<47D68B9D.1E6F.00AA.0@novell.com>
	<1205265642.18463.82.camel@linuxdt036.nc.catapult.com>
	<1205322793.20205.9.camel@linuxdt036.nc.catapult.com>
	<1205326713.20205.27.camel@linuxdt036.nc.catapult.com>
	<1205332212.20205.33.camel@linuxdt036.nc.catapult.com>
	<1205510009.29658.83.camel@linuxdt036.nc.catapult.com>
	<20080314093814.3147f250@laptopd505.fenrus.org>
	<1205515282.29658.111.camel@linuxdt036.nc.catapult.com>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2008 13:21:22 -0400
"Joel K. Greene" <joel.greene@catapult.com> wrote:

> Hi Arjan,
> 
> Thanks for your response. 
> 
> Sorry for the long post, I think the issue required a lot of detail.
> I'm sure that it was easy to overlook that this is still an issue in
> a 6 week old kernel:
> >  Yesterday I pulled down 2.6.16.60 from kernel.org and built that
> > kernel with HZ=1000 and reproduced the problem in about 7 hours.

I did see that, doesn't mean it's not 3 years old...




-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
