Return-Path: <linux-kernel-owner+w=401wt.eu-S1765104AbXJSKUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765104AbXJSKUr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 06:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756878AbXJSKUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 06:20:41 -0400
Received: from mail.gmx.net ([213.165.64.20]:58087 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752150AbXJSKUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 06:20:40 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18cSXIjzdEc2U3sm4+gz+UwkCArF+VVPmmtz8cKPX
	2XP1r3R1Byuwkq
Subject: Re: [bisected][mismerge?] Re: [microcode] 2.6.23.git pulled this
	morning oopses loading P4 microcode
From: Mike Galbraith <efault@gmx.de>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20071019085555.GB3809@implementation.uk.xensource.com>
References: <1192681533.7147.5.camel@Homer.simpson.net>
	 <1192730198.7182.18.camel@Homer.simpson.net>
	 <20071018223333.GD4153@implementation>
	 <1192762138.6838.13.camel@Homer.simpson.net>
	 <20071019085555.GB3809@implementation.uk.xensource.com>
Content-Type: text/plain
Date: Fri, 19 Oct 2007 12:20:37 +0200
Message-Id: <1192789237.7389.33.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-19 at 09:55 +0100, Samuel Thibault wrote:
> Just to make sure, could you check in System.map that accent_table is
> correctly 256*3*4=3072 bytes long?

See mail I just sent.  A day a half wasted here.  Sorry for however much
time you wasted on this.

	-Mike

