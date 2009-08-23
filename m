Return-Path: <linux-kernel-owner+w=401wt.eu-S934007AbZHWRgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934007AbZHWRgh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 13:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbZHWRgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 13:36:36 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54411 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbZHWRgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 13:36:35 -0400
Date: Sun, 23 Aug 2009 18:36:21 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Richard Purdie <rpurdie@rpsys.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mario Schwalbe <schwalbe@inf.tu-dresden.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] video: mbp_nvidia_bl: add support for MacBookAir 1,1
Message-ID: <20090823173621.GA24477@srcf.ucam.org>
References: <1251040684-10399-1-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251040684-10399-1-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 23, 2009 at 05:18:04PM +0200, Henrik Rydberg wrote:
> This patch adds LCD backlight support for the Intel GMA965
> found in the MacBookAir 1,1.

Acked-by: Matthew Garrett <mjg@redhat.com>

With the proviso that this should probably be disabled once the i915 drm 
grows a proper backlight driver.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
