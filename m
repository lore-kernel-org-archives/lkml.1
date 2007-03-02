Return-Path: <linux-kernel-owner+w=401wt.eu-S1030659AbXCBWjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030659AbXCBWjk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 17:39:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030660AbXCBWjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 17:39:40 -0500
Received: from rrcs-24-153-217-226.sw.biz.rr.com ([24.153.217.226]:41072 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030659AbXCBWjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 17:39:39 -0500
Subject: Re: Someone please turn on the http protocol on git.kernel.org!
From: Steve Wise <swise@opengridcomputing.com>
To: Timur Tabi <timur@freescale.com>
Cc: Mike Accetta <maccetta@laurelnetworks.com>, linux-kernel@vger.kernel.org
In-Reply-To: <45E8A571.9030601@freescale.com>
References: <7TYYU-5L8-11@gated-at.bofh.it> <7U2zx-392-13@gated-at.bofh.it>
	 <45E8220D.9040905@laurelnetworks.com>  <45E8A571.9030601@freescale.com>
Content-Type: text/plain
Date: Fri, 02 Mar 2007 16:39:38 -0600
Message-Id: <1172875178.21241.68.camel@stevo-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-02 at 16:30 -0600, Timur Tabi wrote:
> Mike Accetta wrote:
> 
> > error: Couldn't get 
> > http://www.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git/refs/tags/v2.6.11 
> > for tags/v2.6.11
> > The requested URL returned error: 404
> > error: Could not interpret tags/v2.6.11 as something to pull
> 
> I just tried it and got the same error, so it looks like something is wrong on the server.
> 
> Isn't 2.6.11 around the time that Linus moved to git?  Maybe the server can't find tag for 
> the initial check-in of the code.
> 

Aren't the older commits in another git tree?  Like maybe 

git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/old-2.6-bkcvs.git


Steve.

