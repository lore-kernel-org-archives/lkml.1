Return-Path: <linux-kernel-owner+w=401wt.eu-S1753371AbXDVWbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbXDVWbW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 18:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250AbXDVWbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 18:31:22 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53307 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753201AbXDVWbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 18:31:21 -0400
Date: Sun, 22 Apr 2007 15:31:11 -0700
From: Paul Jackson <pj@sgi.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: akpm@linux-foundation.org, mingo@elte.hu, ego@in.ibm.com, oleg@tv-sign.ru,
       linux-kernel@vger.kernel.org, vatsa@in.ibm.com, paulmck@us.ibm.com,
       pavel@ucw.cz
Subject: Re: [RFC][PATCH -mm 2/3] freezer: Introduce freezer_flags
Message-Id: <20070422153111.8f8837c0.pj@sgi.com>
In-Reply-To: <200704230014.42100.rjw@sisk.pl>
References: <20070419120131.GB13435@in.ibm.com>
	<200704222139.27128.rjw@sisk.pl>
	<20070422141452.a7855599.pj@sgi.com>
	<200704230014.42100.rjw@sisk.pl>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael wrote:
> I'll try to explain how it works.

Ok - thanks.  Good explanation of how it works.

One more question - why would I want to do this?

Is this like something that would be useful on a laptop, to suspend
activity and reduce battery drain, while preserving the current state
of ones sessions and avoiding having to logout or shutdown?

Or are there other good uses for this?

Is it useful for quietting a system down before doing hot plug or
unplug of key components, such as processors and memory?

Thanks.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
