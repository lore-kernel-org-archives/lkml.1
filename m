Return-Path: <linux-kernel-owner+w=401wt.eu-S1757285AbXKFVSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285AbXKFVSM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 16:18:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754843AbXKFVR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 16:17:56 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:53915 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682AbXKFVRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 16:17:53 -0500
Date: Tue, 6 Nov 2007 13:17:14 -0800
From: Greg KH <greg@kroah.com>
To: Badari Pulavarty <pbadari@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: mm snapshot broken-out-2007-11-06-02-32.tar.gz uploaded
Message-ID: <20071106211714.GA10863@kroah.com>
References: <200711061033.lA6AXrhT018804@imap1.linux-foundation.org> <1194377549.26782.13.camel@dyn9047017100.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1194377549.26782.13.camel@dyn9047017100.beaverton.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2007 at 11:32:29AM -0800, Badari Pulavarty wrote:
> On Tue, 2007-11-06 at 02:33 -0800, akpm@linux-foundation.org wrote:
> > The mm snapshot broken-out-2007-11-06-02-32.tar.gz has been uploaded to
> > 
> >    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-11-06-02-32.tar.gz
> > 
> > It contains the following patches against 2.6.24-rc1:
> 
> 
> Getting OOPS on shutdown.

Yes, Corneila also reported this and I can duplicate it here.  Am
working on narrowing it down...

thanks,

greg k-h
