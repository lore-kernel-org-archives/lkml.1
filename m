Return-Path: <linux-kernel-owner+w=401wt.eu-S1754031AbZDMX6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbZDMX6u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 19:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbZDMX6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 19:58:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:53246 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827AbZDMX6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 19:58:41 -0400
Date: Sun, 12 Apr 2009 19:44:45 -0700
From: Greg KH <gregkh@suse.de>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       Darren Salt <linux@youmustbejoking.demon.co.uk>
Subject: Re: [PATCH 0/3] Fix rt28{6,7}0sta to use firmware loader
Message-ID: <20090413024445.GA12860@suse.de>
References: <1239589992.18110.117.camel@deadeye.i.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239589992.18110.117.camel@deadeye.i.decadent.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 13, 2009 at 03:33:12AM +0100, Ben Hutchings wrote:
> Greg,
> 
> The Ralink drivers rt2860sta, rt2870sta and rt3070sta contain non-free
> firmware which should be distributed separately.

Where is it now distributed?  I don't want to break people's machines
that were working before this patch is applied.

thanks,

greg k-h
