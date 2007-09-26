Return-Path: <linux-kernel-owner+w=401wt.eu-S1759494AbXIZD46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759494AbXIZD46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 23:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757941AbXIZD4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 23:56:49 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48794 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756336AbXIZD4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 23:56:49 -0400
Date: Wed, 26 Sep 2007 04:56:41 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] put_user() on struct is not nice
Message-ID: <20070926035641.GN8181@ftp.linux.org.uk>
References: <E1IaLAA-000853-8q@ZenIV.linux.org.uk> <1190772346.2227.56.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190772346.2227.56.camel@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2007 at 12:05:46PM +1000, Rusty Russell wrote:
> On Wed, 2007-09-26 at 01:54 +0100, Al Viro wrote:
> > use copy_to_user() instead...
> 
> Thanks Al, Jes sent me the same fix which I have queued for for 2.6.24:

OK, decision on urgency is up to you - post .23 is fine by me...
