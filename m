Return-Path: <linux-kernel-owner+w=401wt.eu-S1752254AbZDSX11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254AbZDSX11 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 19:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbZDSX1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 19:27:01 -0400
Received: from main.gmane.org ([80.91.229.2]:40086 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052AbZDSX1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 19:27:00 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bojan Smojver <bojan@rexursive.com>
Subject: Re: [PATCH RFC] ext3 data=guarded v3
Date: Sun, 19 Apr 2009 23:26:48 +0000 (UTC)
Message-ID: <loom.20090419T232336-411@post.gmane.org>
References: <1239816159-6868-1-git-send-email-chris.mason@oracle.com> <49E63110.60507@redhat.com>
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

Eric Sandeen <sandeen <at> redhat.com> writes:

> Chris, thanks for getting this going.  I think this is a great idea, as
> it gives us most of the performance benefits of writeback without the
> security issues.

Shouldn't writeback be fixed (if performance impact isn't too great), instead of
having a new mode?

--
Bojan



