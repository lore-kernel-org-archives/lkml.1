Return-Path: <linux-kernel-owner+w=401wt.eu-S1753296AbYF0EE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbYF0EE7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 00:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750803AbYF0EEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 00:04:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:35546 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbYF0EEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 00:04:48 -0400
Date: Thu, 26 Jun 2008 20:47:55 -0700
From: Greg KH <gregkh@suse.de>
To: Ben Collins <ben.collins@canonical.com>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] keyspan: Remove duplicate device entries
Message-ID: <20080627034755.GA7763@suse.de>
References: <1214525296.7150.120.camel@cunning>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214525296.7150.120.camel@cunning>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 08:08:16PM -0400, Ben Collins wrote:
> The 28xb, as documented in comments, has the same ID's as the 28x.
> Remove the duplicated ID's from the device tables, and expand the
> comment to document this.

Was this causing a problem somehow?  How did you notice this?  Good
catch.

I'll add it to my queue, thanks,

greg k-h
