Return-Path: <linux-kernel-owner+w=401wt.eu-S1758678AbYFLVpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678AbYFLVpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 17:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbYFLVpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 17:45:19 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47224 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268AbYFLVpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 17:45:14 -0400
Message-ID: <485198E5.80109@garzik.org>
Date: Thu, 12 Jun 2008 17:45:09 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] final PCI patches for 2.6.26
References: <200806121334.01562.jbarnes@virtuousgeek.org>
In-Reply-To: <200806121334.01562.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> Some of these may not have seen review on linux-pci, so I'm sending them out
> for comment before I send Linus the pull request.
> 
> Any comments/objections?
> 
> The biggest patch by far is the resource_wc stuff; it should have been pushed
> earlier, but for some reason I thought Ingo & co. were going to do that...
> 
> Thanks,
> Jesse
> 
> commit a123c3d9643464c56417680536ed9515f15cffa1
> Author: Yinghai Lu <Yinghai.Lu@Sun.COM>
> Date:   Mon May 12 21:21:05 2008 +0200

Although I quite appreciate the addition of patches, IMO it would be 
easier to read if the patch descriptions and patches were not mixed 
together.

Most 'git pull' things I've seen include a changeset summary (shortlog) 
and cumulative patch, when its a single email.  Sometimes (i.e. GregKH 
and a few others) the individual patches are posted in separate emails.

Either way, it saves one from having to wade through a long email, just 
to get an idea of the sum total of the changes...

Regards,

	Jeff




