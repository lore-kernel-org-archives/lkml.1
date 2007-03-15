Return-Path: <linux-kernel-owner+w=401wt.eu-S1422853AbXCOGkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422853AbXCOGkB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 02:40:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422841AbXCOGkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 02:40:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:52369 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422832AbXCOGkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 02:40:00 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH take3 16/20] acpi files switched
Date: Thu, 15 Mar 2007 02:36:42 -0400
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
References: <20070315051337.488091591@goodmis.org> <20070315051532.400874263@goodmis.org>
In-Reply-To: <20070315051532.400874263@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703150236.43214.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 March 2007 01:13, Steven Rostedt wrote:
> Moved the shared files that were in arch/i386/kernel/acpi to the common
> area.

When I do a "make cscope" on an i386 or an x86_64 box,
will it find these files in the common area?

thanks
-Len
