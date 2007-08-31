Return-Path: <linux-kernel-owner+w=401wt.eu-S965512AbXHaNih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965512AbXHaNih (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 09:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965159AbXHaNiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 09:38:25 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58575 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965118AbXHaNiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 09:38:23 -0400
Message-ID: <46D819CE.5050207@garzik.org>
Date: Fri, 31 Aug 2007 09:38:22 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Divy Le Ray <divy@chelsio.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 9/11] cxgb3 - engine microcode update
References: <20070822034947.9404.87301.stgit@speedy5>
In-Reply-To: <20070822034947.9404.87301.stgit@speedy5>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Divy Le Ray wrote:
> From: Divy Le Ray <divy@chelsio.com>
> 
> Load microcode engine when the interface
> is configured up.
> Bump up version to 1.1.0.
> Allow the driver to be and running with
> older microcode images.
> Allow ethtool to log the microcode version.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

ACK patches 9-14, but dropped, since they do not apply to #upstream 
(probably due to fixes sent into 2.6.23-rc)


