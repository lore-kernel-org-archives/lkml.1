Return-Path: <linux-kernel-owner+w=401wt.eu-S1756890AbYEaAgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890AbYEaAgP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 20:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753145AbYEaAgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 20:36:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41311 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbYEaAf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 20:35:59 -0400
Date: Fri, 30 May 2008 17:32:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Subject: via agp patches
Message-ID: <20080531003214.GA6208@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently VIA has been distributing some pre-build kernel modules for
their latest video cards without the source for it.  So I asked, and got
the patches.  I've forward ported them to the current 2.6.26-rc4 tree,
and they also apply cleanly to 2.6.25 as well.  They are here in the
three emails after this one.

I'm still working on getting some more information on exactly what these
patches each do for a good changelog, but until then, if anyone has the
hardware and wants to play with the code, here it is.

If anyone has any questions, please let me know.

thanks,

greg k-h
