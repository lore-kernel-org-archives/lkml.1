Return-Path: <linux-kernel-owner+w=401wt.eu-S1757454AbYAXU2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454AbYAXU2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 15:28:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756536AbYAXU2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 15:28:31 -0500
Received: from 1wt.eu ([62.212.114.60]:1600 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754163AbYAXU2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 15:28:30 -0500
Date: Thu, 24 Jan 2008 20:56:24 +0100
From: Willy Tarreau <w@1wt.eu>
To: dann frazier <dannf@dannf.org>
Cc: linux-kernel@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] 2.4: fix memory corruption from misinterpreted bad_inode_ops return values
Message-ID: <20080124195624.GJ8953@1wt.eu>
References: <20080124061212.GA22079@ldl.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080124061212.GA22079@ldl.fc.hp.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dann,

On Wed, Jan 23, 2008 at 11:12:12PM -0700, dann frazier wrote:
> This is a 2.4 backport of a linux-2.6 change by Eric Sandeen
> (commit be6aab0e9fa6d3c6d75aa1e38ac972d8b4ee82b8)
> 
> CVE-2006-5753 was assigned for this issue.
> 
> I've built and boot-tested this, but I'm not sure how to exercise
> these codepaths.

I have no idea either. Let's consider that if nobody on the list knows
how to do so, I'll merge it since you did not notice any regression.

Thanks,
Willy

