Return-Path: <linux-kernel-owner+w=401wt.eu-S1753386AbZGUQqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbZGUQqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 12:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751136AbZGUQqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 12:46:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47972 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124AbZGUQqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 12:46:38 -0400
Date: Tue, 21 Jul 2009 09:42:12 -0700
From: Greg KH <gregkh@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] Driver core: make pm operations a const pointer
Message-ID: <20090721164212.GA14493@suse.de>
References: <20090721055136.GB4671@dtor-d630.eng.vmware.com>
 <200907211546.49906.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907211546.49906.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 03:46:49PM +0200, Rafael J. Wysocki wrote:
> Hi Dmitry,
> 
> Please always Cc linux-pm on PM-related patches.
> 
> On Tuesday 21 July 2009, Dmitry Torokhov wrote:
> > From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > 
> > They are not supposed to be modified by drivers, so make them const.
> 
> OK, I guess I should handle this.
> 
> Greg, is the patch fine with you?

Yes, feel free to add:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

thanks,

greg k-h
