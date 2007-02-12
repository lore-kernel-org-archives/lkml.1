Return-Path: <linux-kernel-owner+w=401wt.eu-S1030194AbXBLW0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030194AbXBLW0t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 17:26:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030208AbXBLW0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 17:26:48 -0500
Received: from one.firstfloor.org ([213.235.205.2]:60274 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030194AbXBLW0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 17:26:47 -0500
From: Andi Kleen <andi@firstfloor.org>
To: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [PATCH x86 for review III] [12/29] x86_64: 32-bit ptrace mangles sixth system call argument
Date: Mon, 12 Feb 2007 23:26:23 +0100
User-Agent: KMail/1.9.5
Cc: Jeff Dike <jdike@addtoit.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
References: <20070212551.664370000@suse.de> <20070212165132.6518713F45@wotan.suse.de> <45D0E486.9020104@redhat.com>
In-Reply-To: <45D0E486.9020104@redhat.com>
Organization: -
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702122326.23406.andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Didn't we have problems with this exact approach before? This one was dropped
> because it caused 32-bit programs to crash:
> http://www2.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.13/2.6.13-mm2/broken-out/x86-64-ptrace-ia32-bp-fix.patch
> 
> See:
> 	http://lkml.org/lkml/2005/09/16/261
> 
> for the one I proposed instead.

Yes you're right. I dropped it for now.

-Andi
