Return-Path: <linux-kernel-owner+w=401wt.eu-S1161135AbXCNLVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161135AbXCNLVB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 07:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161141AbXCNLVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 07:21:01 -0400
Received: from smtp.osdl.org ([65.172.181.24]:60355 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161135AbXCNLVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 07:21:00 -0400
Date: Wed, 14 Mar 2007 04:17:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nilshar@gmail.com
Cc: "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [Bug 8040] Hang before INIT when CONFIG_HIGHMEM4G=y
Message-Id: <20070314041710.770708c4.akpm@linux-foundation.org>
In-Reply-To: <200703141013.l2EADP6c027144@fire-2.osdl.org>
References: <200703141013.l2EADP6c027144@fire-2.osdl.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 14 Mar 2007 03:13:25 -0700 bugme-daemon@bugzilla.kernel.org wrote:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=8040
> 
> 
> 
> 
> 
> ------- Additional Comments From Nilshar@gmail.com  2007-03-14 03:13 -------
> Any news on that bug please ?

None whatsoever.  Three people are reporting this and it's a drop-dead
showstopper for a 2.6.21 release so we just have to wait until someone
wakes up and thinks about it.

It would be very useful if one of the reporters could perform a git-bisect
search to identify the offending change, please.

I would dearly like to point you at a document or web page which describes
kernel-git-bisect-for-newbies, but afaik there isn't such a thing, which is
a huge failing.

