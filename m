Return-Path: <linux-kernel-owner+w=401wt.eu-S1755654AbXJ1R7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654AbXJ1R7h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 13:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbXJ1R7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 13:59:25 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59485 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbXJ1R7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 13:59:25 -0400
Message-ID: <4724CDFA.1080106@garzik.org>
Date: Sun, 28 Oct 2007 13:59:22 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Bradley Smith <bradjsmith@btinternet.com>
CC: linux-kernel@vger.kernel.org, dz@debian.org
Subject: Re: [PATCH 1/2] I8K: Allow i8k driver to be built on x86_64 systems
References: <20071028172519.371dbbe8@debian.hob>
In-Reply-To: <20071028172519.371dbbe8@debian.hob>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bradley Smith wrote:
> From: Bradley Smith <bradjsmith@btinternet.com>
> 
> Adds #if clause and additional inline assembly so that the driver
> builds on x86_64 systems.
> 
> Signed-off-by: Bradley Smith <bradjsmith@btinternet.com>

Is this actually known to be working on a Dell laptop?

	Jeff



