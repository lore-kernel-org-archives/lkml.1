Return-Path: <linux-kernel-owner+w=401wt.eu-S932458AbXDJCBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458AbXDJCBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 22:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932478AbXDJCBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 22:01:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932458AbXDJCBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 22:01:17 -0400
Date: Mon, 9 Apr 2007 22:01:07 -0400
From: Dave Jones <davej@redhat.com>
To: Dave Dillow <dave@thedillows.org>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jeff@garzik.org>
Subject: Re: I give up
Message-ID: <20070410020107.GF1994@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Dave Dillow <dave@thedillows.org>,
	Jan Engelhardt <jengelh@linux01.gwdg.de>,
	Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jeff@garzik.org>
References: <200704091007.58535.gene.heskett@gmail.com> <Pine.LNX.4.61.0704091848150.21426@yvahk01.tjqt.qr> <461A71FA.40900@zytor.com> <200704091538.44253.gene.heskett@gmail.com> <Pine.LNX.4.61.0704092334410.22295@yvahk01.tjqt.qr> <1176157330.4767.12.camel@dillow.idleaire.net> <20070410012754.GD1994@redhat.com> <1176169246.3193.2.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1176169246.3193.2.camel@obelisk.thedillows.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2007 at 09:40:46PM -0400, Dave Dillow wrote:
 
 > > However, it also doesn't explain what the point is of backing up /dev
 > > when it's dynamically created.
 > 
 > It's not /dev he's backing up -- its /home, /usr, and others. GNU tar
 > saves the device and inode numbers from the {,l}stat() call on each file
 > and decides it is a new file if either number changes from run to run.

Ah apologies, I jumped into the thread halfway, and misunderstood the problem.

	Dave

-- 
http://www.codemonkey.org.uk
