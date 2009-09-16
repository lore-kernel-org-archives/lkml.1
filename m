Return-Path: <linux-kernel-owner+w=401wt.eu-S1759913AbZIPSGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759913AbZIPSGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 14:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759879AbZIPSGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 14:06:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56440 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759780AbZIPSGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 14:06:07 -0400
Date: Wed, 16 Sep 2009 19:06:09 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Convert WM8350 to use request_threaded_irq()
Message-ID: <20090916180609.GA10150@rakim.wolfsonmicro.main>
References: <1253123092-8278-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253123092-8278-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Cookie: You're at Witt's End.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 06:44:52PM +0100, Mark Brown wrote:
> Instead of hand rolling our own variant.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Sorry, git format-patch doesn't do what I want when there's an old
version of the patch present - I'll resend the version I meant to send
in a minute.
