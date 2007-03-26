Return-Path: <linux-kernel-owner+w=401wt.eu-S1751466AbXC0Aao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466AbXC0Aao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 20:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbXC0Aao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 20:30:44 -0400
Received: from ozlabs.org ([203.10.76.45]:50799 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978AbXC0Aan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 20:30:43 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown
Content-Transfer-Encoding: 7bit
Message-ID: <17928.22390.108151.757973@cargo.ozlabs.ibm.com>
Date: Tue, 27 Mar 2007 09:29:58 +1000
From: Paul Mackerras <paulus@samba.org>
To: Badari Pulavarty <pbadari@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, fenkes@de.ibm.com,
       lkml <linux-kernel@vger.kernel.org>, benh@kernel.crashing.org
Subject: Re: 2.6.21-rc4-mm1
In-Reply-To: <1174938450.16728.8.camel@dyn9047017100.beaverton.ibm.com>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
	<1174938450.16728.8.camel@dyn9047017100.beaverton.ibm.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Badari Pulavarty writes:

> Patch causing the problem in -mm:
> 	ibmebus-uevent-support.patch
> 
> I don't see where $,1rx(Bof_device_uevent$,1ry(B is defined :(

That patch depends on another one from Sylvain Munaut that I haven't
yet managed to get Ben H. to express an opinion on, and which isn't in
-mm.  I thought I mentioned that to Andrew, but maybe I only intended
to...

Paul.

