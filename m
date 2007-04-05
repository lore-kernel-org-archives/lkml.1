Return-Path: <linux-kernel-owner+w=401wt.eu-S1161095AbXDEDOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161095AbXDEDOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 23:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161094AbXDEDOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 23:14:18 -0400
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:64786 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161095AbXDEDOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 23:14:17 -0400
Subject: Re: [PATCH] Lguest32 print hex on bad reads and writes
From: Steven Rostedt <rostedt@goodmis.org>
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, virtualization@lists.osdl.org,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <72C854B9-1A7F-44C5-9D62-B6B63F3A6DE7@mac.com>
References: <1175714071.9371.31.camel@localhost.localdomain>
	 <1175742090.12230.630.camel@localhost.localdomain>
	 <72C854B9-1A7F-44C5-9D62-B6B63F3A6DE7@mac.com>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 23:14:08 -0400
Message-Id: <1175742848.9371.33.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-04 at 23:06 -0400, Kyle Moffett wrote:

> > (Erk, I wonder what I was thinking when I wrote that?) Can I ask  
> > for %#x (or 0x%x)?  I'm easily confused.
> 
> How about "%p" for pointers?

But that would require casting the numbers to pointers.

-- Steve


