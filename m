Return-Path: <linux-kernel-owner+w=401wt.eu-S1754732AbXECHzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbXECHzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 03:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161105AbXECHzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 03:55:00 -0400
Received: from il.qumranet.com ([82.166.9.18]:43750 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754732AbXECHy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 03:54:59 -0400
Message-ID: <46399551.2000506@qumranet.com>
Date: Thu, 03 May 2007 10:54:57 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jiri Kosina <jikos@jikos.cz>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: Re: [GIT PULL] KVM updates for Linux 2.6.22
References: <11781765833054-git-send-email-avi@qumranet.com> <Pine.LNX.4.64.0705030943560.16923@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0705030943560.16923@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Thu, 3 May 2007, Avi Kivity wrote:
>
>   
>> Signed-off-by: Anthony Liguori (1):
>>       KVM: SVM: Only save/restore MSRs when needed
>>     
>
> BTW the author name here looks bogus.
>   

I missed that, thanks.  Fixed and pushed, location hasn't changed.

-- 
error compiling committee.c: too many arguments to function

