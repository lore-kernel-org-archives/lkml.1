Return-Path: <linux-kernel-owner+w=401wt.eu-S1756161AbXD2FCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbXD2FCM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 01:02:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754580AbXD2FCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 01:02:12 -0400
Received: from main.gmane.org ([80.91.229.2]:59580 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756161AbXD2FCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 01:02:11 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bojan Smojver <bojan@rexursive.com>
Subject: Re: Back to the future.
Date: Sun, 29 Apr 2007 05:01:50 +0000 (UTC)
Message-ID: <loom.20070429T065020-381@post.gmane.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net>  <200704281950.30405.rjw@sisk.pl>  <alpine.LFD.0.98.0704281421140.9964@woody.linux-foundation.org>  <200704290103.38409.rjw@sisk.pl>  <alpine.LFD.0.98.0704281640480.9964@woody.linux-foundation.org> <1177804898.7652.10.camel@nigel.suspend2.net>
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

> If you want a full
> just-as-if-I'd-never-turned-the-power-off image,

Which (full images save) makes the system most responsive on resume. Coupled
with compression and async I/O also keeps Suspend2 very, very fast, even with a
slow disk and large amounts of RAM (as tested on one of my crappy old
notebooks). From my (user) point of view, this is a brilliant feature to have.

--
Bojan

