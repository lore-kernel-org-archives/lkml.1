Return-Path: <linux-kernel-owner+w=401wt.eu-S1762055AbXGFASP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762055AbXGFASP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 20:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759229AbXGFAR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 20:17:58 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60072 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753803AbXGFAR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 20:17:56 -0400
Date: Thu, 5 Jul 2007 17:17:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       James.Bottomley@steeleye.com, edwintorok@gmail.com, axboe@kernel.dk,
       linux-scsi@vger.kernel.org
Subject: Re: [patch 3/4] Enable link power management for ata drivers
Message-Id: <20070705171735.134fe77f.akpm@linux-foundation.org>
In-Reply-To: <468D8680.1090005@garzik.org>
References: <20070705194909.337398431@intel.com>
	<20070705130530.5873afeb.kristen.c.accardi@intel.com>
	<20070705153334.08402809.akpm@linux-foundation.org>
	<20070705153718.3aaf8ea5.akpm@linux-foundation.org>
	<468D8680.1090005@garzik.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Jul 2007 20:02:08 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> May I assume that I may delete the patches from Kristen, and assume that 
> you will resend an updated version of her AN and ALPM patches to me?
> 

Sure.  But I have a sneaking feeling that Kristen sneaks sneaky fixes into
her patches without telling me, so I won't be 100% confident about their
uptodateness (hint).


