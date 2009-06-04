Return-Path: <linux-kernel-owner+w=401wt.eu-S1755896AbZFDOCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896AbZFDOCf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 10:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754199AbZFDOC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 10:02:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47668 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542AbZFDOC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 10:02:26 -0400
Message-ID: <4A27D3DC.7080400@redhat.com>
Date: Thu, 04 Jun 2009 17:02:04 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, davdel@xmailserver.org,
       mst@redhat.com, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org
Subject: Re: [KVM PATCH v2 0/2] irqfd: use POLLHUP notification for close()
References: <20090604124047.10544.38861.stgit@dev.haskins.net>
In-Reply-To: <20090604124047.10544.38861.stgit@dev.haskins.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> (Applies to kvm.git/master:25deed73)
>
> Please see the header for 2/2 for a description.  This patch series has been
> fully tested and appears to be working correctly.
>
>   

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

