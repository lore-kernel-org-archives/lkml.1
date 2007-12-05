Return-Path: <linux-kernel-owner+w=401wt.eu-S1753899AbXLESKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbXLESKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 13:10:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbXLESK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 13:10:29 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:54651 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbXLESK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 13:10:28 -0500
Date: Wed, 5 Dec 2007 13:09:59 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@osdl.org>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH] UML - change sigcontext fields to match x86
Message-ID: <20071205180959.GA7934@c2.user-mode-linux.org>
References: <20071205163024.GA7241@c2.user-mode-linux.org> <20071205164816.GB25641@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment
In-Reply-To: <20071205164816.GB25641@elte.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2007 at 05:48:16PM +0100, Ingo Molnar wrote:
> thanks, we indeed missed those. Should we carry this in x86.git, or 
> would you like to carry this in your UML tree?

Probably better for it to go in x86.git - that way it travels with
your sigcontext patch.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
