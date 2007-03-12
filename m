Return-Path: <linux-kernel-owner+w=401wt.eu-S965445AbXCLJmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965445AbXCLJmx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 05:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965442AbXCLJmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 05:42:53 -0400
Received: from colin.muc.de ([193.149.48.1]:3554 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965445AbXCLJmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 05:42:52 -0400
Date: 12 Mar 2007 10:42:49 +0100
Date: Mon, 12 Mar 2007 10:42:49 +0100
From: Andi Kleen <ak@muc.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH] BUILD_BUG_ON_ZERO -> BUILD_BUG_OR_ZERO
Message-ID: <20070312094249.GA23326@muc.de>
References: <1173655694.32234.213.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173655694.32234.213.camel@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 10:28:13AM +1100, Rusty Russell wrote:
> BUILD_BUG_ON_ZERO is named perfectly wrong, and BUILD_BUG_ON_RETURN_ZERO
> is too long.  Flip three bits, and the name is much more suitable.

Ok for me.

-Andi
