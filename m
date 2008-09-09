Return-Path: <linux-kernel-owner+w=401wt.eu-S1756139AbYIIHge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbYIIHge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 03:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754160AbYIIHg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 03:36:26 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:16783 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657AbYIIHgZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 03:36:25 -0400
Message-Id: <48C643B2.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Tue, 09 Sep 2008 08:36:50 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Yinghai Lu" <yhlu.kernel@gmail.com>, <tglx@linutronix.de>,
       <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86: x86_{phys,virt}_bits field also for i386 (v2)
References: <48C13D1C.76E4.0078.0@novell.com>
 <20080905150030.GD10292@elte.hu> <48C51F8D.76E4.0078.0@novell.com>
 <20080908134019.GB11993@elte.hu> <20080908185417.GA17654@elte.hu>
 <48C6406E.76E4.0078.0@novell.com> <20080909073153.GA10049@elte.hu>
In-Reply-To: <20080909073153.GA10049@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Ingo Molnar <mingo@elte.hu> 09.09.08 09:31 >>>
>there's nothing weird about this testbox (it's a usual whitebox) - and 
>two other testboxes failed as well after some time (no crashlog 
>available from them). A 64-bit testbox didnt fail so it seems 32-bit 
>only.

I just spotted it - it's a mismerge on my part. Will send v3 in a minute.

Jan

