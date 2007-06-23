Return-Path: <linux-kernel-owner+w=401wt.eu-S1754686AbXFWTQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbXFWTQV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 15:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbXFWTQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 15:16:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48420 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbXFWTQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 15:16:13 -0400
Date: Sat, 23 Jun 2007 20:16:09 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tony Jones <tonyj@suse.de>, linux-audit@redhat.com,
       linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/1] audit: fix oops removing watch if audit disabled
Message-ID: <20070623191609.GX21478@ftp.linux.org.uk>
References: <20070620223820.GA16416@suse.de> <20070623095153.279c1194.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070623095153.279c1194.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2007 at 09:51:53AM -0700, Andrew Morton wrote:
> This looks like 2.6.22 material to me.
> 
> Question is: is it also 2.6.21.x material?

Yes, it is.
