Return-Path: <linux-kernel-owner+w=401wt.eu-S1422794AbXBUSkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422794AbXBUSkh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 13:40:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422793AbXBUSkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 13:40:37 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422794AbXBUSkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 13:40:36 -0500
Date: Wed, 21 Feb 2007 13:40:23 -0500
From: Dave Jones <davej@redhat.com>
To: Andreas Schwab <schwab@suse.de>
Cc: Zwane Mwaikambo <zwane@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21-rc1
Message-ID: <20070221184023.GJ19851@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andreas Schwab <schwab@suse.de>,
	Zwane Mwaikambo <zwane@infradead.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> <jeejojmkbq.fsf@sykes.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jeejojmkbq.fsf@sykes.suse.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 07:34:01PM +0100, Andreas Schwab wrote:
 > I'm getting an undefined symbol with CONFIG_AGP=m:
 > 
 > WARNING: "compat_agp_ioctl" [drivers/char/agp/agpgart.ko] undefined!

Fix went to Linus an hour ago.
It's been in -mm for a week, and agpgart.git for a day or so.

		Dave

-- 
http://www.codemonkey.org.uk
