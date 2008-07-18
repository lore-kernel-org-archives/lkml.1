Return-Path: <linux-kernel-owner+w=401wt.eu-S1758030AbYGRVrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030AbYGRVrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 17:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753298AbYGRVq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 17:46:59 -0400
Received: from vena.lwn.net ([206.168.112.25]:54904 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752932AbYGRVq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 17:46:59 -0400
Date: Fri, 18 Jul 2008 15:46:57 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: LKML <linux-kernel@vger.kernel.org>, git@vger.kernel.org
Cc: Greg KH <greg@kroah.com>
Subject: gitdm v0.10 available
Message-ID: <20080718154657.7ff0cf9e@bike.lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.4; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gitdm (the "git data miner") is the tool that Greg KH and I have used
to crank out statistics on where kernel patches come from.  For the
curious, I have (finally) put up a public repository for gitdm at:

	git://git.lwn.net/gitdm.git

That repository is currently tagged at v0.10, for whatever that's worth.

There is a mildly redacted version of the configuration files used in
the creation of kernel statistics at:

	http://lwn.net/images/gitdm/gitdm-config-2.6.26.tar.bz2

If nothing else, the domain->company mapping files should be useful for
anybody who might be interested in using gitdm on projects other than
the kernel.

Please be warned that gitdm is not a polished release of a
production-quality tool; it's something which has been made to work
just well enough for what we needed to do at any given time.  Needless
to say, patches to make it better are welcome.

jon
