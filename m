Return-Path: <linux-kernel-owner+w=401wt.eu-S1752668AbYBDFb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbYBDFb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 00:31:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750900AbYBDFbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 00:31:16 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40748 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbYBDFbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 00:31:15 -0500
Date: Sun, 3 Feb 2008 21:29:00 -0800
From: Greg KH <greg@kroah.com>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-sh <linux-sh@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SH/Dreamcast - fix regressions, whitespace and memory
	leaks in Maple Bus driver
Message-ID: <20080204052900.GB7585@kroah.com>
References: <1202068847.6262.7.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202068847.6262.7.camel@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2008 at 08:00:47PM +0000, Adrian McMenamin wrote:
> From: Adrian McMenamin
> 
> This patch fixes the regression noted here:
> http://lkml.org/lkml/2008/1/26/189 as well as whitespace issues in the
> previous commit of this driver and the memory leaks noted here:
> http://lkml.org/lkml/2008/2/2/143 (as well as one or two other minor
> cleanups).

Which portion of the patch fixes the kobject WARN_ON()?

thanks,

greg k-h
