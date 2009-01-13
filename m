Return-Path: <linux-kernel-owner+w=401wt.eu-S1760214AbZAMJr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760214AbZAMJr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 04:47:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755446AbZAMJrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 04:47:47 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:35163 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbZAMJrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 04:47:46 -0500
Date: Tue, 13 Jan 2009 10:47:33 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Message-ID: <20090113094733.GG31787@enneenne.com>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org> <20090106225744.GA10553@infradead.org> <20090106151915.df138883.akpm@linux-foundation.org> <20090112202237.GA27636@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112202237.GA27636@infradead.org>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: 2.6.29 -mm merge plans
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 03:22:37PM -0500, Christoph Hellwig wrote:
> On Tue, Jan 06, 2009 at 03:19:15PM -0800, Andrew Morton wrote:
> > Well that's a drop-it-all-and-start again scale of thing.
> > 
> > Rodolfo, do you have sufficient information here?
> 
> I think the core is pretty solid and the few things mentioned there
> can be easily fixed up even after the initial merge.

Great, thanks a lot! :)

> pps-documentation-programs-and-examples.patch and
> pps-userland-header-file-for-pps-api.patch should just be dropped
> for now.

Ok.

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
