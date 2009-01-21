Return-Path: <linux-kernel-owner+w=401wt.eu-S1753195AbZAUPZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbZAUPZR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 10:25:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756316AbZAUPZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 10:25:00 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:50883 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755708AbZAUPY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 10:24:58 -0500
Date: Wed, 21 Jan 2009 10:24:53 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, um: fix ELF_CORE_COPY_REGS macro
Message-ID: <20090121152453.GA7800@c2.user-mode-linux.org>
References: <497739E6.4010806@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497739E6.4010806@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 04:06:14PM +0100, Roel Kluin wrote:
> When this macros isn't called with regs, e.g. with foo
> this will incorectly expand to foo->foo.gp[*]
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

ACK.

	Jeff

-- 
Work email - jdike at linux dot intel dot com
