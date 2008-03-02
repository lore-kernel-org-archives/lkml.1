Return-Path: <linux-kernel-owner+w=401wt.eu-S1759274AbYCBUEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759274AbYCBUEx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 15:04:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754912AbYCBUEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 15:04:45 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:40248 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713AbYCBUEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 15:04:44 -0500
Date: Sun, 2 Mar 2008 12:04:25 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "Gang He" <hegang.linux@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: OOPS: how to hook system_call_table in redhat es5.1 on x86_64
 platform
Message-ID: <20080302120425.00aac7e3@laptopd505.fenrus.org>
In-Reply-To: <4306ae870803011740k39d0769cy7fd6413b10146f74@mail.gmail.com>
References: <4306ae870803011740k39d0769cy7fd6413b10146f74@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Mar 2008 09:40:14 +0800
"Gang He" <hegang.linux@gmail.com> wrote:

> Hi,
> 
> as you know, Linux kernel (>2.6.18) set some pages read-only, we can
> not hook system_call_table directly like before, the new source code
> on i386 is
> 

Hi,

2 items:
1) lkml is not a tutorial list for how to write rootkits
2) you forgot to point to your full source code; hooking the system call table
   is the wrong thing to do, but by not mentioning your (GPL) source code you
   don't give us the option to give you suggestions on how to achieve what you
   want.

I would suggest you come back to this mailing list with more context on what you
are trying to achieve including a pointer to the source code.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
