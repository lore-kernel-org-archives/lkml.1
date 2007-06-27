Return-Path: <linux-kernel-owner+w=401wt.eu-S1760912AbXF0Gdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760912AbXF0Gdm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 02:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759094AbXF0Gdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 02:33:33 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:37840 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756879AbXF0Gdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 02:33:32 -0400
Message-ID: <468204B9.5000400@garzik.org>
Date: Wed, 27 Jun 2007 02:33:29 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Divy Le Ray <divy@chelsio.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 2.6.22] cxgb3 - fix register to stop bc/mc traffic
References: <20070625221930.19394.90772.stgit@localhost.localdomain>
In-Reply-To: <20070625221930.19394.90772.stgit@localhost.localdomain>
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
> Use the right register to stop broadcast/multicast traffic. 
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

applied to #upstream-fixes


