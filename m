Return-Path: <linux-kernel-owner+w=401wt.eu-S1755452AbYFTTs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbYFTTs3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 15:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751695AbYFTTsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 15:48:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607AbYFTTsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 15:48:21 -0400
Date: Fri, 20 Jun 2008 15:42:00 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Bernhard Walle <bwalle@suse.de>
Cc: kexec@lists.infradead.org, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Introduce userspace interface for Firmware-provided memory map
Message-ID: <20080620194200.GC21235@redhat.com>
References: <1213977420-1555-1-git-send-email-bwalle@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213977420-1555-1-git-send-email-bwalle@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2008 at 05:56:57PM +0200, Bernhard Walle wrote:
> This patch (as request for comments) introduces a new userspace interface
> /proc/firmware_mem that provides the unfiltered view of the BIOS on
> memory configuration. That's usable for two reasons:
> 

How about /proc/firmware_memmap. This is little longish but probably more
clear in intent.

Thanks
Vivek
