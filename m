Return-Path: <linux-kernel-owner+w=401wt.eu-S1754790AbYJBXF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbYJBXF7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 19:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbYJBXFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 19:05:48 -0400
Received: from kroah.org ([198.145.64.141]:41035 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752596AbYJBXFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 19:05:47 -0400
Date: Thu, 2 Oct 2008 16:02:46 -0700
From: Greg KH <greg@kroah.com>
To: xiong.huang@atheros.com, csnook@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: atl2 network driver status
Message-ID: <20081002230246.GA11570@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In looking for drivers to add to drivers/staging/ I ran across the atl2
driver that is currently in the Fedora and Ubuntu kernel trees.

This driver doesn't look to be scheduled for inclusion in the upstream
netdev git tree for submission for 2.6.28, is there any reason why it is
still out-of-the-tree?

And, if it's not going into 2.6.28, any objection for me adding it to
the drivers/staging/ tree?  If so, I need a list of reasons why it is
not merged upstream properly so far so that people know what to work on
in order to get it there.

thanks,

greg k-h
