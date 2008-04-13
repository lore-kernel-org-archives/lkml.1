Return-Path: <linux-kernel-owner+w=401wt.eu-S1757943AbYDMOly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943AbYDMOly (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 10:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbYDMOlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 10:41:47 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:21595 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbYDMOlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 10:41:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=pSxzTQq+rufZ18t7ucwY9I3vGUGLJRQFn1CMOQ7TqHFcixkV1Xc1r2iFYeLA7PjQ5sCSVtR5lxabOiL7Hqr8K9GI7tP1vG39gKgzE79751zQhOw+pyPXUcivdt6PGL8CS1iY0ATqvpRLdn3XSU7YLgijScBkkuFt9u6quVY+VYs=
Date: Sun, 13 Apr 2008 18:41:38 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       tony@atomide.com, paul@pwsan.com, David Brownell <david-b@pacbell.net>
Subject: [PATCH 0/5] Clocklib: generic clocks framework
Message-ID: <20080413144138.GA31665@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is my current version of the patchset.
Changes since last repost:

 * Clean up stuff noted by akpm.
 * Provide debugfs file description
 * Drop SIRCLK name, bind pxaficp driver to the STUARTCLK
 * Drop 3.6MHz clock renames
 * Rebase pxa part to latest Russel's arm:devel patchset

-- 
With best wishes
Dmitry

