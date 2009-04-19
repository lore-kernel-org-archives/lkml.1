Return-Path: <linux-kernel-owner+w=401wt.eu-S1753208AbZDSWjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbZDSWjy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 18:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbZDSWjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 18:39:45 -0400
Received: from main.gmane.org ([80.91.229.2]:39322 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744AbZDSWjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 18:39:45 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bojan Smojver <bojan@rexursive.com>
Subject: Re: ext3 v. ext4 writeback mode
Date: Sun, 19 Apr 2009 22:39:27 +0000 (UTC)
Message-ID: <loom.20090419T223814-459@post.gmane.org>
References: <loom.20090418T022710-681@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 150.101.121.179 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.8) Gecko/2009032713 Fedora/3.0.8-1.fc10 Firefox/3.0.8)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bojan Smojver <bojan <at> rexursive.com> writes:

> Given this part of the diff between ext3.txt and ext4.txt in
> Documentation/filesystems of 2.6.30-rc2, does that mean that ext4 in writeback
> mode can still leave garbage in files after the crash?

Ted answered this in detail here:

http://lwn.net/Articles/329008/

Thanks!

--
Bojan




