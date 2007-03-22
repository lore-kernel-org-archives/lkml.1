Return-Path: <linux-kernel-owner+w=401wt.eu-S933999AbXCVTcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933999AbXCVTcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 15:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934005AbXCVTcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 15:32:31 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:54146 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933999AbXCVTca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 15:32:30 -0400
Date: Thu, 22 Mar 2007 15:29:56 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [ PATCH 0/7 ] UML - Header cleanup
Message-ID: <20070322192956.GA8949@c2.user-mode-linux.org>
References: <20070322160640.GA6992@c2.user-mode-linux.org> <20070322095034.51a16aa5.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070322095034.51a16aa5.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2007 at 09:50:34AM -0800, Andrew Morton wrote:
> I have the ARRAY_SIZE change queued for 2.6.22.
> 
> It looks like the UML change needs to be folded into the same changeset to
> avoid build breaks?

Yes, that would be great.

			Jeff

-- 
Work email - jdike at linux dot intel dot com
