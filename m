Return-Path: <linux-kernel-owner+w=401wt.eu-S1757595AbXITRbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595AbXITRbG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 13:31:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757484AbXITRay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 13:30:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36912 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755711AbXITRax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 13:30:53 -0400
Date: Thu, 20 Sep 2007 18:30:36 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Christoph Hellwig <hch@infradead.org>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docuement filesystem helpers for custom 'struct file's
Message-ID: <20070920173036.GA22142@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Dave Hansen <haveblue@us.ibm.com>,
	Randy Dunlap <randy.dunlap@oracle.com>, akpm@osdl.org,
	linux-kernel@vger.kernel.org
References: <20070917182718.70494C9B@kernel> <20070917182718.A6B9F7FD@kernel> <20070919172611.GA20917@infradead.org> <1190224043.26982.112.camel@localhost> <20070919150724.4e64829a.randy.dunlap@oracle.com> <1190309156.26982.144.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190309156.26982.144.camel@localhost>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2007 at 10:25:56AM -0700, Dave Hansen wrote:
> Should we do comments for every single function argument, or is it OK to
> leave them out for the obvious ones?

Yes, we should keep the kerneldoc comments coherent, even if it seems
useless in a few cases.

