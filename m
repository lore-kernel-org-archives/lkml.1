Return-Path: <linux-kernel-owner+w=401wt.eu-S1754069AbXD1Ujb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbXD1Ujb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 16:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754750AbXD1Ujb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 16:39:31 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:54214 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754069AbXD1Uj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 16:39:28 -0400
Message-ID: <4633B0F3.2000408@garzik.org>
Date: Sat, 28 Apr 2007 16:39:15 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andi Kleen <ak@suse.de>, patches@x86-64.org,
       Vivek Goyal <vgoyal@in.ibm.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for
 relocatable bzImage
References: <20070428758.455116000@suse.de>	<20070428175909.1D09D151CA@wotan.suse.de> <46338D72.70402@garzik.org> <m1fy6kdzi1.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1fy6kdzi1.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

No specific concern; the patch description did not say that bootloader 
people had ACK'd the change, or describe the testing regimen.

Just reading the patch, the impact and preparation were unknowns.

	Jeff



