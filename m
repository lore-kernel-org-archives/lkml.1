Return-Path: <linux-kernel-owner+w=401wt.eu-S1030788AbXD1BUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030788AbXD1BUL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 21:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030775AbXD1BUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 21:20:10 -0400
Received: from main.gmane.org ([80.91.229.2]:50770 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030788AbXD1BUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 21:20:08 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bojan Smojver <bojan@rexursive.com>
Subject: Re: Back to the future.
Date: Sat, 28 Apr 2007 00:28:38 +0000 (UTC)
Message-ID: <loom.20070428T021616-949@post.gmane.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 203.171.74.242 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.10) Gecko/20070313 Fedora/1.5.0.10-5.fc6 Firefox/1.5.0.10)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nigel Cunningham <nigel <at> nigel.suspend2.net> writes:

> 4) uswsusp and swsusp get dropped and Suspend2 goes into mainline.

After reading most of this thread, it seems that Linus is of the view that all
three of these suck in one way or another. Suspend2 has the most features and is
the fastest of the lot. It can behave like swsusp from the user's point of view
(i.e. echo disk > /sys/power/state), so the migration should be seamless for
most distros. It isn't complicated to set up. It's been proven in the field. It
looks pretty.

So, while we're waiting for the next STD technology, why not have the best and
develop from there?

--
Bojan

