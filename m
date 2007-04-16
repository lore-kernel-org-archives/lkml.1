Return-Path: <linux-kernel-owner+w=401wt.eu-S1030800AbXDPQEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030800AbXDPQEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 12:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030810AbXDPQEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 12:04:37 -0400
Received: from cobalt0.barnhard.net ([216.181.81.129]:45883 "EHLO
	cobalt0.barnhard.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030800AbXDPQEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 12:04:37 -0400
Date: Mon, 16 Apr 2007 17:04:22 +0100
From: Dale Amon <amon@vnl.com>
To: Dale Amon <amon@vnl.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Problem with ufs nextstep in 2.6.18 (debian)
Message-ID: <20070416160422.GC5386@vnl.com>
Mail-Followup-To: Dale Amon <amon@vnl.com>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <20070416073204.GA10225@rain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070416073204.GA10225@rain>
X-Operating-System: Linux, the choice of a GNU generation
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2007 at 11:32:04AM +0400, Evgeniy Dushistov wrote:
> >The error also happens in 2.6.19, same as in 2.6.18.
> >I extracted this from syslog: 
> >Apr 17 00:14:15 kdev kernel: UFS-fs error (device loop0):
> >ufs_check_page: bad entry
> 
> Is this happened also with this patch:
> http://lkml.org/lkml/diff/2007/2/5/75/1

Thanks. I will try that out tonight GMT. Which kernel
is that against? Will it work against a 2.6.19 or should
I get a 2.6.20 and work with that?

