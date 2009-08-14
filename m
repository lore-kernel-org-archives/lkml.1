Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039AbZHNVsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbZHNVsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 17:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbZHNVsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 17:48:42 -0400
Received: from kroah.org ([198.145.64.141]:39340 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053AbZHNVsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 17:48:41 -0400
Date: Fri, 14 Aug 2009 14:46:05 -0700
From: Greg KH <greg@kroah.com>
To: David VomLehn <dvomlehn@cisco.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: kfifo: Add "const" attribute to kfifo input buffer pointers
Message-ID: <20090814214605.GA20993@kroah.com>
References: <20090814200254.GA26288@cuplxvomd02.corp.sa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090814200254.GA26288@cuplxvomd02.corp.sa.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 14, 2009 at 01:02:54PM -0700, David VomLehn wrote:
> 
> Change the input buffer arguments for kfifo_put() and __kfifo_put() to have
> the "const" attribute.

Alan Cox already beat you to this one, I have a patch in my tree from
him that does this.

thanks,

greg k-h
