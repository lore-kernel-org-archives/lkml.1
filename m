Return-Path: <linux-kernel-owner+w=401wt.eu-S1757070AbYBHBPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070AbYBHBPa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 20:15:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932221AbYBHBOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 20:14:52 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34522 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932341AbYBHBOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 20:14:51 -0500
Date: Thu, 7 Feb 2008 17:12:30 -0800
From: Greg KH <greg@kroah.com>
To: David Chinner <dgc@sgi.com>
Cc: Greg KH <gregkh@suse.de>, "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, torvalds@linux-foundation.org,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Dave Jones <davej@redhat.com>, akpm@linux-foundation.org,
       Chuck Wolber <chuckw@quantumlinux.com>, stable@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 00/45] 2.6.24-stable review
Message-ID: <20080208011230.GA28390@kroah.com>
References: <20080207204549.GA16389@suse.de> <20080208004430.GE155407@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080208004430.GE155407@sgi.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 11:44:30AM +1100, David Chinner wrote:
> Greg,
> 
> Is there any reason why the XFS patch I sent to the stable list a
> couple of days ago is not included in this series?
> 
> http://oss.sgi.com/archives/xfs/2008-02/msg00027.html
> 
> We've had multiple reports of it, and multiple confirmations that
> the patch in the link above fixes the problem.....

I didn't think it was in Linus's tree yet.  Is it?

thanks,

greg k-h
