Return-Path: <linux-kernel-owner+w=401wt.eu-S1763449AbYB1BFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763449AbYB1BFP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 20:05:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757925AbYB1BFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 20:05:00 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:49115 "EHLO
	outbound5-va3-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755598AbYB1BE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 20:04:59 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-WSS-ID: 0JWXCBP-02-PAH-01
Date: Wed, 27 Feb 2008 18:12:07 -0700
From: Jordan Crouse <jordan.crouse@amd.com>
To: Andres Salomon <dilinger@queued.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, adaplas@gmail.com,
       linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       info-linux@geode.amd.com, dwmw2@infradead.org
Subject: Re: gxfb: Replace FBSIZE config option with a kernel argument
Message-ID: <20080228011207.GB2942@cosmic.amd.com>
References: <20080223011045.48e6cb8e@ephemeral> <20080227163105.e1b96023.akpm@linux-foundation.org> <20080227195839.1e86074e@ephemeral>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080227195839.1e86074e@ephemeral>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-OriginalArrivalTime: 28 Feb 2008 01:04:50.0885 (UTC) FILETIME=[EB922F50:01C879A5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > And "fbsize=N" would be a lot more conventional than "fbsize:N"
> > 
> 
> I can certainly change that.  Regarding convention, I toyed with renaming
> it 'vram' (as most of the fb drivers use that), and will probably do
> that unless Jordan objects.

vram is fine.

Jordan

-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.

