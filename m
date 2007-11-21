Return-Path: <linux-kernel-owner+w=401wt.eu-S1759790AbXKUKdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759790AbXKUKdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 05:33:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754076AbXKUKdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 05:33:37 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:42225 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbXKUKdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 05:33:36 -0500
Date: Wed, 21 Nov 2007 05:31:26 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Avi Kivity <avi@qumranet.com>
cc: Sam Ravnborg <sam@ravnborg.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: 2.6.24-rc3-mm1 make headers_check fails
In-Reply-To: <474405AA.2070608@qumranet.com>
Message-ID: <alpine.LFD.0.9999.0711210530480.13226@localhost.localdomain>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org> <4743EB52.1040205@linux.vnet.ibm.com> <20071120163240.e54beed6.akpm@linux-foundation.org> <4743EF47.5000203@linux.vnet.ibm.com> <4743EFF8.9010307@qumranet.com> <20071121095821.GB1070@uranus.ravnborg.org>
 <474401BB.2020204@qumranet.com> <474405AA.2070608@qumranet.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2007, Avi Kivity wrote:

> headers_check continues to complain.  Is the only recourse to add
> asm/kvm.h for all archs?

that's what's happened with other header files.  see asm-*/auxvec.h,
for example.

rday
--
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
