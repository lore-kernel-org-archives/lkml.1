Return-Path: <linux-kernel-owner+w=401wt.eu-S932309AbXB1TWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309AbXB1TWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 14:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932388AbXB1TWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 14:22:20 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932309AbXB1TWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 14:22:19 -0500
Message-ID: <45E5D63E.5030305@redhat.com>
Date: Wed, 28 Feb 2007 14:21:34 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Neil Brown <neilb@suse.de>
Subject: Re: PROBLEM: null pointer dereference in cfq_dispatch_requests	(2.6.21-rc2
 and 2.6.20)
References: <1172685755.5773.6.camel@dwillia2-linux.ch.intel.com> <45E5CE9E.7050904@redhat.com>
In-Reply-To: <45E5CE9E.7050904@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
> There are two patches for raid5/6 out there that might fix this. I'll
> attach them (the second just fixes a minor bug in the first one.)

Never mind, those patches are already in 2.6.21-rc.

