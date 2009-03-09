Return-Path: <linux-kernel-owner+w=401wt.eu-S1753958AbZCIS4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbZCIS4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 14:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751698AbZCISzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 14:55:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47565 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbZCISzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 14:55:51 -0400
Date: Mon, 9 Mar 2009 20:15:04 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Ozan =?utf-8?B?w4dhxJ9sYXlhbg==?= <ozan@pardus.org.tr>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: suggest running a 64bit kernel on LM capable machines with plenty memory.
Message-ID: <20090309191504.GB11935@one.firstfloor.org>
References: <49B254C6.8010507@pardus.org.tr> <20090307193026.GA2165@x200.localdomain> <49B2CE44.4060305@pardus.org.tr> <87r617ojfi.fsf@firstfloor.org> <1236606168.8389.512.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236606168.8389.512.camel@laptop>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> How about we do the below as well?

Idea looks good, but with your patch it would print two conflicting
messages ("use highmem64. No, use 64bit instead"), wouldn't it? 
Only one would be better.

-Andi
