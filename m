Return-Path: <linux-kernel-owner+w=401wt.eu-S1751366AbXDWGsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366AbXDWGsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 02:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091AbXDWGsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 02:48:20 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42304 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751366AbXDWGsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 02:48:19 -0400
Date: Sun, 22 Apr 2007 23:48:18 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Neil Brown <neilb@suse.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: SLUB: kmem_cache_destroy doesn't - version 2.
In-Reply-To: <17964.21972.961812.744601@notabene.brown>
Message-ID: <Pine.LNX.4.64.0704222345500.5442@schroedinger.engr.sgi.com>
References: <17960.16739.870487.497750@notabene.brown>
 <Pine.LNX.4.64.0704192215420.16306@schroedinger.engr.sgi.com>
 <17960.20796.761309.771912@notabene.brown> <Pine.LNX.4.64.0704192236510.16503@schroedinger.engr.sgi.com>
 <17964.21972.961812.744601@notabene.brown>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2007, Neil Brown wrote:

> Another option might be to name each cache actually created with a
> unique name, and then create a symlink for each cache that was asked
> for (whether it was created or whether a pre-existing cache was used).
> Then being lazy about deletion shouldn't be a problem.

You may be right.

