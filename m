Return-Path: <linux-kernel-owner+w=401wt.eu-S1763162AbYEVV36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763162AbYEVV36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758175AbYEVV3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:29:46 -0400
Received: from beauty.rexursive.com ([203.171.74.242]:33724 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757689AbYEVV3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:29:45 -0400
X-Greylist: delayed 549 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 May 2008 17:29:45 EDT
Subject: Re: capget() overflows buffers.
From: Bojan Smojver <bojan@rexursive.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Dave Jones <davej@codemonkey.org.uk>, Andrew Morgan <morgan@kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080522175744.GE4018@sequoia.sous-sol.org>
References: <20080522140402.GB2071@codemonkey.org.uk>
	 <20080522175744.GE4018@sequoia.sous-sol.org>
Content-Type: text/plain
Date: Fri, 23 May 2008 07:20:29 +1000
Message-Id: <1211491229.23239.91.camel@shrek.rexursive.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-22 at 10:58 -0700, Chris Wright wrote:

> Bojan, is there a capset involved as well, because that will pull in
> garbage and set caps accordingly?

I believe so. It's all part of Squid 3.0 code. File src/tools.cc, line
1386. I would point you to a URL in the source repository, but
squid-cache.org appears to be down right now.

-- 
Bojan

