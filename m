Return-Path: <linux-kernel-owner+w=401wt.eu-S1756687AbXI1NPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbXI1NPb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 09:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbXI1NPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 09:15:24 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:39803 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbXI1NPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 09:15:23 -0400
Date: Fri, 28 Sep 2007 09:15:14 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] use array_size macro
Message-ID: <20070928131514.GA5209@c2.user-mode-linux.org>
References: <46FCDBE9.8030406@tiscali.nl> <46FCDDDF.8020500@tiscali.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46FCDDDF.8020500@tiscali.nl>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2007 at 12:56:31PM +0200, Roel Kluin wrote:
>  arch/um/kernel/tt/ptproxy/ptrace.c      |   12 ++++++------

I don't know what you're diffing against, but this file is history in
-mm, and will be gone in mainline after 2.6.23.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
