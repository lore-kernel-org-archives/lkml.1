Return-Path: <linux-kernel-owner+w=401wt.eu-S934225AbZARQFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934225AbZARQFd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 11:05:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765577AbZARQFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 11:05:13 -0500
Received: from main.gmane.org ([80.91.229.2]:52818 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933732AbZARQFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 11:05:10 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Yanko Kaneti <yaneti@declera.com>
Subject: Re: Checking module parameters
Date: Sun, 18 Jan 2009 15:59:21 +0000 (UTC)
Message-ID: <loom.20090118T155611-13@post.gmane.org>
References: <200901172226.n0HMQEEJ024690@taverner.cs.berkeley.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 212.116.131.122 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b2) Gecko/20090106 Galeon/2.0.7)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Wagner <daw <at> cs.berkeley.edu> writes:

> (I can't set libata.force=1.5Gbps as a kernel argument because on my
> Fedora kernel, libata is loaded as a module rather than built into the
> kernel.  

That used to be true until module-init-tools-3.5 , i.e.  you can in Fedora 10
and rawhide.

Cheers

