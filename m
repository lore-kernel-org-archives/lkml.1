Return-Path: <linux-kernel-owner+w=401wt.eu-S932405AbXBNR7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405AbXBNR7s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 12:59:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932409AbXBNR7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 12:59:47 -0500
Received: from [198.99.130.12] ([198.99.130.12]:33381 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932405AbXBNR7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 12:59:46 -0500
Date: Wed, 14 Feb 2007 12:52:06 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Andi Kleen <ak@suse.de>, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86 for review III] [12/29] x86_64: 32-bit ptrace mangles sixth system call argument
Message-ID: <20070214175206.GC5801@ccure.user-mode-linux.org>
References: <20070212551.664370000@suse.de> <20070212165132.6518713F45@wotan.suse.de> <45D0E486.9020104@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D0E486.9020104@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12, 2007 at 05:04:54PM -0500, Chuck Ebbert wrote:
> See:
> 	http://lkml.org/lkml/2005/09/16/261
> 
> for the one I proposed instead.

That works for me - can we get this into mainline?

				Jeff

-- 
Work email - jdike at linux dot intel dot com
