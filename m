Return-Path: <linux-kernel-owner+w=401wt.eu-S1758930AbZIPTdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758930AbZIPTdB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 15:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754421AbZIPTcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 15:32:55 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37332 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184AbZIPTcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 15:32:55 -0400
Date: Wed, 16 Sep 2009 20:32:50 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tim Abbott <tabbott@ksplice.com>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Nelson Elhage <nelhage@ksplice.com>
Subject: Re: [PATCH v2 2/2] arm: Clean up linker script using new linker
	script macros.
Message-ID: <20090916193250.GD16457@n2100.arm.linux.org.uk>
References: <1253119195-19056-1-git-send-email-tabbott@ksplice.com> <1253119195-19056-3-git-send-email-tabbott@ksplice.com> <20090916191928.GC16457@n2100.arm.linux.org.uk> <alpine.DEB.1.10.0909161522510.2942@dr-wily.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0909161522510.2942@dr-wily.mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 03:31:37PM -0400, Tim Abbott wrote:
> I can resend to the ARM lists if it will work -- I didn't do so this time 
> because I seem to recall that only subscribers can post; maybe I 
> misunderstood the MAINTAINERS entry?
> 
> L:      linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
> 
> Looking at the code, there's definitely something wrong in relation to 
> CONFIG_XIP_KERNEL; I'll fix this and repost CCing 
> linux-arm-kernel@lists.arm.linux.org.uk.

Please use linux-arm-kernel@lists.infradead.org instead.  (We'll
get the patch updating MAINTAINERS in soon.)
