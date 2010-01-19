Return-Path: <linux-kernel-owner+w=401wt.eu-S1755828Ab0ASJGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828Ab0ASJGF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 04:06:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755792Ab0ASJFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 04:05:32 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45303 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753Ab0ASJFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 04:05:21 -0500
Date: Tue, 19 Jan 2010 04:05:21 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Mark Allyn <mark.a.allyn@intel.com>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, alan@linux.intel.com,
       charles.f.johnson@intel.com
Subject: Re: [PATCH] Move rar_register.h file to include/linux/rar
Message-ID: <20100119090521.GA15004@infradead.org>
References: <1263849744-23098-1-git-send-email-mark.a.allyn@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263849744-23098-1-git-send-email-mark.a.allyn@intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 01:22:24PM -0800, Mark Allyn wrote:
> The purpose of this patch is to move the rar_register.h file from
> the driver source code directory to a subdirectory in the kernel's
> include tree; at incluce/linux/rar.

Why do you create a subdirectory for a single header file?

