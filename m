Return-Path: <linux-kernel-owner+w=401wt.eu-S934738AbXEVPti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934738AbXEVPti (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 11:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757071AbXEVPtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 11:49:31 -0400
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:40889 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756407AbXEVPtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 11:49:31 -0400
Date: Tue, 22 May 2007 11:49:28 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Aurelien Jarno <aurelien@aurel32.net>, linux-kernel@vger.kernel.org,
       parisc-linux@lists.parisc-linux.org
Subject: Re: [parisc-linux] [PATCH] parisc: Disable LWS debugging
Message-ID: <20070522154928.GD16717@fattire.cabal.ca>
References: <20070522153825.GA16404@farad.aurel32.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070522153825.GA16404@farad.aurel32.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2007 at 05:38:26PM +0200, Aurelien Jarno wrote:
> The LWS debugging code on parisc is wrongly enabled due to a bug in the
> use of the preprocessor directives. This debugging code is not thread 
> safe and causes problems with a recent glibc on SMP kernels.
> 
> Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>

merged.
