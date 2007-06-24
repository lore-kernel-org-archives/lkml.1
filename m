Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbXFXIfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbXFXIfW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 04:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbXFXIfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 04:35:12 -0400
Received: from mtoichi11.ns.itscom.net ([219.110.2.181]:55590 "EHLO
	mtoichi11.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbXFXIfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 04:35:10 -0400
Date: Sun, 24 Jun 2007 17:33:40 +0900
From: Mattia Dongili <malattia@linux.it>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>,
       linux-usb-devel@lists.sourceforge.net,
       ipw3945-devel@lists.sourceforge.net
Subject: it's iwl3945 [Re: can't suspend on vaio sz (rc4 and rc5 are ok) [was Re: 2.6.22-rc4-mm2]
Message-ID: <20070624083339.GA4418@inferi.kami.home>
References: <20070622092518.GD25100@inferi.kami.home> <Pine.LNX.4.44L0.0706220957560.3290-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0706220957560.3290-100000@iolanthe.rowland.org>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.22-rc4-mm2-1 i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2007 at 09:59:47AM -0400, Alan Stern wrote:
> I've lost track of the start of this thread, so it would help to see a
...

Hi,
sorry for the previous spam about not suspending.

It turns out it's actually due to iwl3945.
Looking at the changelog there's been a recent fix for suspend/resume
issues, I just tested the latest snapshot (0.0.32) which indeed works.

apologies again,
-- 
mattia
:wq!
