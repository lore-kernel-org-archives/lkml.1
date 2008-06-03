Return-Path: <linux-kernel-owner+w=401wt.eu-S1753493AbYFCPqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbYFCPqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 11:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbYFCPqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 11:46:23 -0400
Received: from waste.org ([66.93.16.53]:39533 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807AbYFCPqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 11:46:23 -0400
Subject: Re: [PATCH] console - Add configurable support for console charset
	translation
From: Matt Mackall <mpm@selenic.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tim Bird <tim.bird@am.sony.com>, linux-tiny <Linux-tiny@selenic.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux-embedded <linux-embedded@vger.kernel.org>
In-Reply-To: <48449FAE.70404@zytor.com>
References: <48447615.5050806@am.sony.com>  <48449FAE.70404@zytor.com>
Content-Type: text/plain
Date: Tue, 03 Jun 2008 10:46:04 -0500
Message-Id: <1212507964.3953.67.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-06-02 at 18:34 -0700, H. Peter Anvin wrote:
> Tim Bird wrote:
> > With CONSOLE_TRANSLATIONS turned off, this saves about 6K
> > on my kernel configured for an ARM development board (OMAP
> > 5912 OSK).  In embedded products I'm familiar with,
> > console translations are not needed.
> 
> On most embedded products I'm familiar with, you wouldn't have virtual 
> consoles at all...?

Actually, lots have frame buffers these days.

-- 
Mathematics is the supreme nostalgia of our time.

