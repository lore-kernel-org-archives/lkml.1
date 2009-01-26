Return-Path: <linux-kernel-owner+w=401wt.eu-S1752179AbZAZEKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179AbZAZEKS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 23:10:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbZAZEKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 23:10:05 -0500
Received: from main.gmane.org ([80.91.229.2]:38850 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbZAZEKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 23:10:04 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Matt LaPlante <kernel1@cyberdogtech.com>
Subject: Re: [PATCH 2/2] Kconfig cleanup - new.
Date: Mon, 26 Jan 2009 03:09:07 +0000 (UTC)
Message-ID: <loom.20090126T030440-921@post.gmane.org>
References: <1232569236-11926-1-git-send-email-kernel1@cyberdogtech.com> <49791C06.6010805@oracle.com> <20090125000214.55608957.kernel@cyberdogtech.com> <alpine.LNX.1.10.0901251804000.5377@jikos.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 76.29.218.130 (Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US) AppleWebKit/525.19 (KHTML, like Gecko) Chrome/1.0.154.43 Safari/525.19)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina <jkosina <at> suse.cz> writes:

> 
> On Sun, 25 Jan 2009, Matt LaPlante wrote:
> 
> > Thanks - spacing fixed; patch below.
> 
> Hi Matt,
> 
> thanks for the fixes. Is there any specific reason why you splitted the 
> patches in two? I'd just fold them together if you don't mind.
> 

Simply for expedience of review.  I realize that trivial patches such as these 
are pretty low priority, and I didn't want to waste the reviewers time re-
checking the entire first batch which had been already been validated but never 
merged.  I have no problem folding them into one for inclusion.


