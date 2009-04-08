Return-Path: <linux-kernel-owner+w=401wt.eu-S1763772AbZDHPub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763772AbZDHPub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 11:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754875AbZDHPuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 11:50:05 -0400
Received: from rtr.ca ([76.10.145.34]:45277 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452AbZDHPuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 11:50:04 -0400
Message-ID: <49DCC7A8.9020803@rtr.ca>
Date: Wed, 08 Apr 2009 11:50:00 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, jgarzik@redhat.com,
       David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: [PATCH 4/5] ide: Add support for TRIM
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com> <1238683047-13588-2-git-send-email-willy@linux.intel.com> <1238683047-13588-3-git-send-email-willy@linux.intel.com> <1238683047-13588-4-git-send-email-willy@linux.intel.com> <49DCB5A5.7040100@rtr.ca> <49DCBBE2.4050506@garzik.org>
In-Reply-To: <49DCBBE2.4050506@garzik.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Mark Lord wrote:
..
>> So it's not obvious exactly why this command even needs data to
>> be transfered.
> 
> It's a list of LBA ranges, like the NV-cache stuff recently added.
..

Ack.  Thanks.  I found the LBA range description (intact) in the drafts now.

-ml
