Return-Path: <linux-kernel-owner+w=401wt.eu-S1755534AbZCYCqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbZCYCqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 22:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753921AbZCYCq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 22:46:26 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:45704 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753659AbZCYCqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 22:46:25 -0400
Message-ID: <49C99AFC.8040107@garzik.org>
Date: Tue, 24 Mar 2009 22:46:20 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/4] pata_artop: Serializing support
References: <20090324101952.9152.30261.stgit@localhost.localdomain> <20090324102139.9152.87330.stgit@localhost.localdomain>
In-Reply-To: <20090324102139.9152.87330.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> From: Alan Cox <alan@redhat.com>
> 
> Enable both ports on the 6210 and serialize them
> 
> Signed-off-by: Alan Cox <alan@redhat.com>
> ---
> 
>  block/blk-settings.c     |    2 +-

applied 1-2, after removing the block/* comment changes (not my area)


