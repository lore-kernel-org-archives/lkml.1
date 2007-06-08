Return-Path: <linux-kernel-owner+w=401wt.eu-S966918AbXFHBZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966918AbXFHBZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 21:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934880AbXFHBZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 21:25:37 -0400
Received: from havoc.gtf.org ([69.61.125.42]:55513 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933212AbXFHBZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 21:25:36 -0400
Date: Thu, 7 Jun 2007 21:25:34 -0400
From: Jeff Garzik <jeff@garzik.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>,
       Alistair John Strachan <s0348365@sms.ed.ac.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel-rng: Undo mess made by an 80 column extremist
Message-ID: <20070608012534.GB23290@havoc.gtf.org>
References: <20070607162251.5f291325@the-village.bc.nu> <m3wsyfzcpt.fsf@maximus.localdomain> <200706072232.37051.s0348365@sms.ed.ac.uk> <m3sl93zagi.fsf@maximus.localdomain> <4668AC10.9060305@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4668AC10.9060305@zytor.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 06:08:32PM -0700, H. Peter Anvin wrote:
> My big concern with the 80-column rule is that it discourages commenting.

My concern with that logic is that encourages random, super-wide code
lines that varies with each coder.  You are left to the mercy of he with
the widest text window.

The 80-column rule is good as a general guideline, though there are
obvious exceptions.  Comments IMO are not one of them.  That rapidly
creates unreadable code.

	Jeff



