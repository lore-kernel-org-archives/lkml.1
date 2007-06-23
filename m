Return-Path: <linux-kernel-owner+w=401wt.eu-S1755823AbXFWTUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823AbXFWTUU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 15:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752849AbXFWTUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 15:20:09 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52344 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752781AbXFWTUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 15:20:07 -0400
Date: Sat, 23 Jun 2007 12:19:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Tony Jones <tonyj@suse.de>, linux-audit@redhat.com,
       linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/1] audit: fix oops removing watch if audit disabled
Message-Id: <20070623121925.e1127d9e.akpm@linux-foundation.org>
In-Reply-To: <20070623191609.GX21478@ftp.linux.org.uk>
References: <20070620223820.GA16416@suse.de>
	<20070623095153.279c1194.akpm@linux-foundation.org>
	<20070623191609.GX21478@ftp.linux.org.uk>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jun 2007 20:16:09 +0100 Al Viro <viro@ftp.linux.org.uk> wrote:

> On Sat, Jun 23, 2007 at 09:51:53AM -0700, Andrew Morton wrote:
> > This looks like 2.6.22 material to me.
> > 
> > Question is: is it also 2.6.21.x material?
> 
> Yes, it is.

OK, thanks, I queued it for both kernels.
