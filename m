Return-Path: <linux-kernel-owner+w=401wt.eu-S1751937AbZHaLp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbZHaLp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 07:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbZHaLp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 07:45:29 -0400
Received: from tundra.namei.org ([65.99.196.166]:58931 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872AbZHaLp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 07:45:28 -0400
Date: Mon, 31 Aug 2009 21:44:05 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Pavel Machek <pavel@ucw.cz>
cc: Siarhei Liakh <sliakh.lkml@gmail.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH V2] x86: NX protection for kernel data
In-Reply-To: <20090831103948.GA1353@ucw.cz>
Message-ID: <alpine.LRH.2.00.0908312143140.19946@tundra.namei.org>
References: <817ecb6f0908261020y2267218h8f435e8dc392f69a@mail.gmail.com> <20090831103948.GA1353@ucw.cz>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Aug 2009, Pavel Machek wrote:

> .c files are considered bad these days. (Feel free to kill the old
> entries, too.)

No, please don't delete historical information.


- James
-- 
James Morris
<jmorris@namei.org>
