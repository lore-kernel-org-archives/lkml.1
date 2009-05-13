Return-Path: <linux-kernel-owner+w=401wt.eu-S1761895AbZEMVcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761895AbZEMVcQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 17:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761581AbZEMVb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 17:31:58 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53233 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761495AbZEMVb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 17:31:57 -0400
Message-ID: <4A0B3C36.4020904@garzik.org>
Date: Wed, 13 May 2009 17:31:34 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Hitoshi Mitake <h.mitake@gmail.com>, Roland Dreier <rdreier@cisco.com>,
       Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>, tglx@linutronix.de,
       rpjday@crashcourse.ca, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Remove readq()/writeq() on 32-bit
References: <49EE37AF.4020507@zytor.com>	 <20090421.173123.191021055.davem@davemloft.net>	 <adak55438gp.fsf_-_@cisco.com>	 <20090428.221228.217954247.davem@davemloft.net>	 <20090429115654.GC11586@elte.hu> <49F843BC.7020902@garzik.org>	 <adahc071ie4.fsf@cisco.com> <49F8B1A1.4010208@garzik.org> <a6b9f31a0905122232s2d23b4e3h6e447c3fa5c29ee6@mail.gmail.com> <4A0B30D0.4060806@garzik.org> <4A0B3605.8090007@zytor.com> <4A0B3BF3.1050804@garzik.org>
In-Reply-To: <4A0B3BF3.1050804@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> The burden of special casing for bizarre hardware should not fall on 
> /sane/ drivers and hardware, who should be the ones opting _out_ of the 
> standard regime.

opting out refers to the bizarre hardware, of course.

Poor sentence construction.  Sometimes I myself wonder if English is my 
primary language...

	Jeff



