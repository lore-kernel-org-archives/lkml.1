Return-Path: <linux-kernel-owner+w=401wt.eu-S1752825AbZDEEvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbZDEEvm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 00:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750894AbZDEEvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 00:51:32 -0400
Received: from main.gmane.org ([80.91.229.2]:48341 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbZDEEvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 00:51:31 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bojan Smojver <bojan@rexursive.com>
Subject: Re: Ext4 and the "30 second window of death"
Date: Sun, 5 Apr 2009 04:51:13 +0000 (UTC)
Message-ID: <loom.20090405T044907-340@post.gmane.org>
References: <200903291224.21380.info@gnebu.es> <20090331122540.GB13356@mit.edu> <loom.20090403T060217-420@post.gmane.org> <loom.20090405T034232-367@post.gmane.org>
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

> 1. Rename the fully synced temp file into "foo".

Forgot to mention... At which point the current config kept in memory would be
dumped, if the reference count of temp files associated with it reached zero.

--
Bojan




