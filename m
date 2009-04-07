Return-Path: <linux-kernel-owner+w=401wt.eu-S1758611AbZDGACx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611AbZDGACx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 20:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757502AbZDGACc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 20:02:32 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:42371 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757857AbZDGACb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 20:02:31 -0400
Message-ID: <49DA9812.2080802@garzik.org>
Date: Mon, 06 Apr 2009 20:02:26 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Matthew Wilcox <willy@linux.intel.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       jgarzik@redhat.com, David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: [PATCH 3/5] ata: Add TRIM infrastructure
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com> <1238683047-13588-2-git-send-email-willy@linux.intel.com> <1238683047-13588-3-git-send-email-willy@linux.intel.com>
In-Reply-To: <1238683047-13588-3-git-send-email-willy@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> This is common code shared between the IDE and libata implementations
> 
> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> ---
>  include/linux/ata.h |   41 +++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 41 insertions(+), 0 deletions(-)

applied


