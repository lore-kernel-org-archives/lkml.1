Return-Path: <linux-kernel-owner+w=401wt.eu-S1762220AbZDHFza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762220AbZDHFza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 01:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760452AbZDHFzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 01:55:14 -0400
Received: from relay3.sgi.com ([192.48.156.57]:52620 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757960AbZDHFzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 01:55:13 -0400
Date: Wed, 8 Apr 2009 00:55:07 -0500
From: Robin Holt <holt@sgi.com>
To: Alex Chiang <achiang@hp.com>
Cc: Robin Holt <holt@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org
Subject: Re: cross-compilers
Message-ID: <20090408055507.GO10764@sgi.com>
References: <20090408003921.GA5054@ldl.fc.hp.com> <20090408010331.GB10768@sgi.com> <20090408054612.GA6744@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090408054612.GA6744@ldl.fc.hp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07, 2009 at 11:46:12PM -0600, Alex Chiang wrote:
> * Robin Holt <holt@sgi.com>:
> > Don't know if this answers your problem, but I use the tools from
> > emdebian and they do not suffer from the problems you list below.
> 
> Wow, this seems _much_ simpler. Once you get the toolchain
> installed, all you have to do is set ARCH and CROSS_COMPILE
> appropriately?

That is all I do.

Robin
