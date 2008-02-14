Return-Path: <linux-kernel-owner+w=401wt.eu-S932992AbYBNV7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932992AbYBNV7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 16:59:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755044AbYBNV7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 16:59:08 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:58742 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753620AbYBNV7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 16:59:05 -0500
Message-ID: <47B4B9A7.4080304@garzik.org>
Date: Thu, 14 Feb 2008 16:59:03 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gdth: convert to PCI hotplug API
References: <20080212234928.GA13892@havoc.gtf.org> <47B2CF57.9030308@panasas.com>
In-Reply-To: <47B2CF57.9030308@panasas.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh wrote:
> do you intend this to be pushed into 2.6.25-rcx or this is already
> for 2.6.26? Should we put this in -mm tree for testing?


Not intended for 2.6.25.  I just wanted to get this "in process" 
somewhere, and keep this issue moving.  I would definitely prefer to 
have this tested before it goes to Linus.

Its a long term goal to kill pci_find_device(), and this conversion was 
a side effect of that.

	Jeff



