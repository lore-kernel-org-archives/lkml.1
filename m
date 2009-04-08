Return-Path: <linux-kernel-owner+w=401wt.eu-S1762229AbZDHFqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762229AbZDHFqZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 01:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758369AbZDHFqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 01:46:14 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:22853 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757890AbZDHFqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 01:46:13 -0400
Date: Tue, 7 Apr 2009 23:46:12 -0600
From: Alex Chiang <achiang@hp.com>
To: Robin Holt <holt@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org
Subject: Re: cross-compilers
Message-ID: <20090408054612.GA6744@ldl.fc.hp.com>
References: <20090408003921.GA5054@ldl.fc.hp.com> <20090408010331.GB10768@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090408010331.GB10768@sgi.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Robin Holt <holt@sgi.com>:
> Don't know if this answers your problem, but I use the tools from
> emdebian and they do not suffer from the problems you list below.

Wow, this seems _much_ simpler. Once you get the toolchain
installed, all you have to do is set ARCH and CROSS_COMPILE
appropriately?

I guess the question remains for Andrew. Since I pretty much did
all the work needed to update his cross-compiler repo, is there
still value in it?

Or shall we just recommend emdebian to everyone? :)

Thanks.

/ac

