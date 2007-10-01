Return-Path: <linux-kernel-owner+w=401wt.eu-S1755900AbXJASmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900AbXJASmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 14:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbXJASmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 14:42:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314AbXJASmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 14:42:13 -0400
Date: Mon, 1 Oct 2007 14:39:40 -0400
From: Bill Nottingham <notting@redhat.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Antonino Daplas <adaplas@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] make unicode default
Message-ID: <20071001183940.GA16413@nostromo.devel.redhat.com>
Mail-Followup-To: Jan Engelhardt <jengelh@computergmbh.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Antonino Daplas <adaplas@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0709291034100.22032@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709291034100.22032@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt (jengelh@computergmbh.de) said: 
> 
> Make the vt return to the system default when it is reset.
> Also make UTF-8 the system default.
> Derived from http://lkml.org/lkml/2007/8/31/246
> 
> Tested and works as expected.

Fine with me. I believe the original patch I sent went to -mm, so you 
may need rediffing/changing to go with that.

Bill
