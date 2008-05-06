Return-Path: <linux-kernel-owner+w=401wt.eu-S1765061AbYEFVpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765061AbYEFVpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 17:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbYEFVpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 17:45:17 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:43012 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbYEFVpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 17:45:15 -0400
Date: Tue, 6 May 2008 17:44:35 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: nix@esperi.org.uk, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [PATCH 11/19] UML - Track and make up lost ticks
Message-ID: <20080506214435.GA12998@c2.user-mode-linux.org>
References: <20080425175613.GA11192@c2.user-mode-linux.org> <877iegcx11.fsf@hades.wkstn.nix> <20080429202924.GA13602@c2.user-mode-linux.org> <20080506134655.4cac1014.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080506134655.4cac1014.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 01:46:55PM -0700, Andrew Morton wrote:
> This fix was already present in your "[PATCH 4/19] UML - Random driver fixes".

Ah, so that's where it ended up.

> Perhaps we broke bisection?

No doubt.  Drop those two and I'll send fixed ones.

   	   	      Jeff

-- 
Work email - jdike at linux dot intel dot com
