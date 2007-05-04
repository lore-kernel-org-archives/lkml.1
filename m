Return-Path: <linux-kernel-owner+w=401wt.eu-S1031431AbXEDR2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031431AbXEDR2W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 13:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031432AbXEDR2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 13:28:22 -0400
Received: from terminus.zytor.com ([192.83.249.54]:54419 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031431AbXEDR2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 13:28:21 -0400
Message-ID: <463B6D02.50909@zytor.com>
Date: Fri, 04 May 2007 10:27:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 3/3] boot bzImages under paravirt
References: <1178283582.23670.67.camel@localhost.localdomain>	<1178283724.23670.70.camel@localhost.localdomain>	<1178284052.23670.75.camel@localhost.localdomain>	<m1ps5gslfm.fsf@ebiederm.dsl.xmission.com> <463B4E12.50703@goop.org> <m1r6pwr0yy.fsf@ebiederm.dsl.xmission.com> <463B6C8A.9080206@goop.org>
In-Reply-To: <463B6C8A.9080206@goop.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> We should be able to make do with that until we've got our own gdt.
> 

It's harsh being without %ss and %es.

	-hpa
