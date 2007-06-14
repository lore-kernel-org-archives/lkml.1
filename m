Return-Path: <linux-kernel-owner+w=401wt.eu-S1752471AbXFNFLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbXFNFLq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 01:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750851AbXFNFLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 01:11:36 -0400
Received: from terminus.zytor.com ([192.83.249.54]:50730 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbXFNFLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 01:11:35 -0400
Message-ID: <4670CDF0.808@zytor.com>
Date: Wed, 13 Jun 2007 22:11:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Oleg Verych <olecom@flower.upol.cz>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Andi Kleen <ak@suse.de>,
       Jeff Garzik <jeff@garzik.org>, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: arch/i386/boot rewrite, and all the hard-coded video cards
References: <463698D5.20102@zytor.com> <alpine.LFD.0.98.0704301940320.3808@woody.linux-foundation.org> <4637A3F6.70508@gmail.com> <alpine.LFD.0.98.0705011433050.3808@woody.linux-foundation.org> <4637B6B5.5060502@zytor.com> <E1HyhJM-00045g-09@flower>
In-Reply-To: <E1HyhJM-00045g-09@flower>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Verych wrote:
> Thus, text mode on modern hardware isn't useable that much, only with
> Terminus font it is kind of normal (kudos to Dimitar Toshkov Jekov).
> But it's only option to unfortunately sucking X11, even with memory
> bandwidth, you are talking about.

That's another reason to use the framebuffer console on laptops.

	-hpa
