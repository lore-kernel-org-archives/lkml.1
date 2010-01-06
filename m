Return-Path: <linux-kernel-owner+w=401wt.eu-S1755434Ab0AFHIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab0AFHIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 02:08:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751679Ab0AFHIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 02:08:30 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34297 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab0AFHI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 02:08:29 -0500
Date: Wed, 6 Jan 2010 08:08:07 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Huang Ying <ying.huang@intel.com>
Cc: lenb@kernel.org, ak@linux.intel.com, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 4/5] ACPI, APEI, EINJ support
Message-ID: <20100106070807.GA1494@ucw.cz>
References: <1261980744-4450-1-git-send-email-ying.huang@intel.com> <1261980744-4450-2-git-send-email-ying.huang@intel.com> <1261980744-4450-3-git-send-email-ying.huang@intel.com> <1261980744-4450-4-git-send-email-ying.huang@intel.com> <1261980744-4450-5-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261980744-4450-5-git-send-email-ying.huang@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-12-28 14:12:23, Huang Ying wrote:
> EINJ provides a hardware error injection mechanism, this is useful for
> debugging and testing of other APEI and RAS features.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> ---
>  drivers/acpi/apei/Kconfig  |    7 +
>  drivers/acpi/apei/Makefile |    1 +
>  drivers/acpi/apei/einj.c   |  471 ++++++++++++++++++++++++++++++++++++++++++++


Can we get more meaningfull name? err_inject.c?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
