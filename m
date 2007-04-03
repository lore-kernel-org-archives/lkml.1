Return-Path: <linux-kernel-owner+w=401wt.eu-S1753233AbXDCG0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbXDCG0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 02:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250AbXDCG0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 02:26:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233AbXDCG0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 02:26:20 -0400
Date: Mon, 2 Apr 2007 23:24:39 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: Jiri Kosina <jkosina@suse.cz>, stuart_hayes@dell.com,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       zaitcev@redhat.com
Subject: Re: usb hid: reset NumLock
Message-Id: <20070402232439.9012663c.zaitcev@redhat.com>
In-Reply-To: <200704030104.06754.dtor@insightbb.com>
References: <20070330105924.01a16dd6.zaitcev@redhat.com>
	<Pine.LNX.4.64.0704021641190.3808@jikos.suse.cz>
	<20070402161225.2866c002.zaitcev@redhat.com>
	<200704030104.06754.dtor@insightbb.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2007 01:04:05 -0400, Dmitry Torokhov <dtor@insightbb.com> wrote:

> What do you think?

The patch looks sane, although I haven't yet tested it. I'll live with
it until next quarterly update, then consider if I should take it or use
my patch for RHEL 5 and RHEL 4.

-- Pete
