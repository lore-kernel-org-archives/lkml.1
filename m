Return-Path: <linux-kernel-owner+w=401wt.eu-S932634AbXCMTGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634AbXCMTGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 15:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932873AbXCMTGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 15:06:38 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54297 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932634AbXCMTGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 15:06:38 -0400
Date: Tue, 13 Mar 2007 19:06:37 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Johann Borck <johann.borck@densedata.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: considering kevent - the kernel development process
Message-ID: <20070313190637.GA900@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Johann Borck <johann.borck@densedata.com>,
	linux-kernel@vger.kernel.org
References: <45F6F590.8030909@densedata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F6F590.8030909@densedata.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

please cut your cc lines next time, thanks.

On Tue, Mar 13, 2007 at 08:03:44PM +0100, Johann Borck wrote:
> if the next section seems obvious, please skip it
> -------------------------------------------------------------------------
> There is a need for a generic event handling mechanism in Linux - maybe 
> it is enough to cite the current CGL Performance Requirements Definition
> Version 4.0 at
> http://developer.osdl.org/dev/cgl/cgl40/cgl40-performance.pdf , page 13:
> 
> PRF.5.0     Efficient Low-Level Asynchronous Events  Priority P1            
> Description: OSDL CGL specifies that carrier grade Linux shall provide 
> an efficient capability for handling a large number of essentially 
> simultaneous asynchronous events arriving on multiple channels, such as
> multiple sockets or other similar paths. This mechanism is needed to 
> enforce system scalability and soft real-time responsiveness by
> reducing contentions appearing at the kernel level, especially under 
> high load.

It's not obvious, but utter bullshit.  Please go away if you think
starting post with quotes from CGL specs is even remotely close to
a good idea.

