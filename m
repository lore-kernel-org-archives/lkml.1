Return-Path: <linux-kernel-owner+w=401wt.eu-S1753498AbYEOUos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbYEOUos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 16:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763916AbYEOUoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 16:44:37 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:57311 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbYEOUog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 16:44:36 -0400
Date: Thu, 15 May 2008 16:43:18 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>, virtualization@lists.osdl.org,
       Rusty Russell <rusty@rustcorp.com.au>, jeremy@xensource.com,
       Herbert Xu <herbert@gondor.apana.org.au>, Avi Kivity <avi@qumranet.com>
Subject: Re: Virt RNG?
Message-ID: <20080515204318.GA14008@c2.user-mode-linux.org>
References: <482C8595.5030509@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482C8595.5030509@garzik.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 02:48:53PM -0400, Jeff Garzik wrote:
> Has anyone yet written a "hw" RNG module for virt, that reads the host's 
> random number pool?

UML has one, probably not usable as-is by anyone else right now...

    	     	      Jeff

-- 
Work email - jdike at linux dot intel dot com
