Return-Path: <linux-kernel-owner+w=401wt.eu-S1758258AbXGDQq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258AbXGDQq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 12:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619AbXGDQqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 12:46:50 -0400
Received: from gw.goop.org ([64.81.55.164]:47507 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754029AbXGDQqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 12:46:49 -0400
Message-ID: <468BCEF8.4010904@goop.org>
Date: Wed, 04 Jul 2007 09:46:48 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, patches@x86-64.org
Subject: Re: [PATCH] x86: make SMP locks handling interact properly	with	CONFIG_DEBUG_RODATA
 (2nd try)
References: <468BE77E.76E4.0078.0@novell.com>
In-Reply-To: <468BE77E.76E4.0078.0@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
>> Oh, sorry, I forgot to remove that part of the comment after merging up to
>> 2.6..22-rcX.
>>     
>
> Actually, no, the comment is right - it talks about pieces left in x86-64's
> vmlinux.lds.S.

Hm.  I was pretty sure I did that too, but maybe it was in a separate 
patch which got lost.

    J
