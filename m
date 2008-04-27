Return-Path: <linux-kernel-owner+w=401wt.eu-S1765357AbYD0XVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765357AbYD0XVU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 19:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205AbYD0XVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 19:21:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53930 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbYD0XVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 19:21:07 -0400
Message-ID: <4815097F.3000105@zytor.com>
Date: Sun, 27 Apr 2008 16:17:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Breakage caused by unreviewed patch in x86 tree
References: <1209329485.3801.46.camel@localhost.localdomain>	 <20080427155803.73f0efcf@laptopd505.fenrus.org> <1209337439.3801.84.camel@localhost.localdomain>
In-Reply-To: <1209337439.3801.84.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> My major complaint is the lack of review and notice, not the actual
> patch.

[...]

> I wouldn't have picked ... I'd have asked for input.

I can't speak for anyone else, but I definitely have discussed this 
issue with a large number of people.  I can't tell you in which specific 
fora, because it usually became a very brief conversation since there 
really is only one plausible answer (*especially* in the light of the 
precedents set by other architectures.)

Ingo's mention of it on LKML in this email:

	http://lkml.org/lkml/2008/1/25/287

... is pretty typical of how the conversation usually went.

	-hpa
