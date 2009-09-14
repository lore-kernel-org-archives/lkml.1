Return-Path: <linux-kernel-owner+w=401wt.eu-S1755152AbZINIMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbZINIMh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 04:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754831AbZINIMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 04:12:36 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56615 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828AbZINIMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 04:12:36 -0400
Date: Mon, 14 Sep 2009 09:12:21 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mikael Pettersson <mikpe@it.uu.se>, James Morris <jmorris@namei.org>,
       David Howells <dhowells@redhat.com>
Subject: Re: linux-next: manual merge of the security-testing tree with the
	arm tree
Message-ID: <20090914081220.GA14204@flint.arm.linux.org.uk>
References: <20090903154700.2d4538cf.sfr@canb.auug.org.au> <20090914130355.ff26d669.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090914130355.ff26d669.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 01:03:55PM +1000, Stephen Rothwell wrote:
> This is now a conflict between the arm tree and Linus' tree (as the
> security-testing tree has been merged).

That's going to be a problem then - I've sent Linus a pull request last
Saturday, and so my tree is now frozen pending a response from Linus.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
