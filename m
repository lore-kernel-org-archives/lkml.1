Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434AbZHCVCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbZHCVCZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 17:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbZHCVCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 17:02:24 -0400
Received: from kroah.org ([198.145.64.141]:57314 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634AbZHCVCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 17:02:24 -0400
Date: Mon, 3 Aug 2009 14:00:54 -0700
From: Greg K-H <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Martyn Welch <martyn.welch@gefanuc.com>
Subject: [patch 0/5] [ANNOUNCE] VME Bus drivers and framework for Linux
Message-ID: <20090803210054.GA28430@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here's 5 patches from Martyn Welch that adds VME Bus support to the
kernel.

Martyn took the time and merged the three different existing
implementations for Linux together into something that works, and got
the proper legal agreements from all of the affected parties to release
the code properly.

I'd like to thank him for taking the time to do this work, it is much
appreciated.

These patches all add the code under the drivers/staging/ directory, as
there is still a number of things that needs to be done to clean up the
code to get it into "proper" mergable state, but it's a great first cut.

Thanks again Martyn!

greg k-h
