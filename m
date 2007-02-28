Return-Path: <linux-kernel-owner+w=401wt.eu-S1752062AbXB1V0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbXB1V0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 16:26:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbXB1V0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 16:26:35 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbXB1V0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 16:26:34 -0500
Date: Wed, 28 Feb 2007 16:26:16 -0500
From: Dave Jones <davej@redhat.com>
To: Michael Hanselmann <linux-kernel@hansmi.ch>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Antonino Daplas <adaplas@pol.net>
Subject: Re: fix implicit declaration in nv_backlight.
Message-ID: <20070228212616.GC5169@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Michael Hanselmann <linux-kernel@hansmi.ch>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Antonino Daplas <adaplas@pol.net>
References: <20070228173625.GA3359@redhat.com> <20070228211324.GA26983@hansmi.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070228211324.GA26983@hansmi.ch>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 28, 2007 at 10:13:24PM +0100, Michael Hanselmann wrote:
 > On Wed, Feb 28, 2007 at 12:36:25PM -0500, Dave Jones wrote:
 > > +#ifdef __powerpc__
 > 
 > Is __powerpc__ defined when cross compiling? I'd rather use
 > CONFIG_PMAC_BACKLIGHT instead of it.

Sounds ok to me.

		Dave

-- 
http://www.codemonkey.org.uk
