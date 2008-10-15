Return-Path: <linux-kernel-owner+w=401wt.eu-S1756018AbYJOOoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbYJOOoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 10:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbYJOOoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 10:44:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52999 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbYJOOoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 10:44:06 -0400
Message-ID: <48F601A5.1050405@redhat.com>
Date: Wed, 15 Oct 2008 09:43:49 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: pterjan@mandriva.org, linux-ext4@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Possible ext3 corruption with 1K block size
References: <200810150724.42180.arvidjaar@mail.ru> <48F5E6D4.8080603@redhat.com> <200810151824.36119.arvidjaar@mail.ru>
In-Reply-To: <200810151824.36119.arvidjaar@mail.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Borzenkov wrote:
> On Wednesday 15 October 2008, Eric Sandeen wrote:


>> My kingdom for a testcase... does anyone have simple steps to reproduce
>> this?  Or do they all start with "install mandriva on a 1k block size
>> system?"  :)
>>
> 
> May be RH will do? :)

I did try a 1k-block root fs Fedora install, and didn't see any problems...

> As indicated by last comment, Pascal has some ways to trigger it; I
> forgot to Cc to him initially; doing it now.

Ok, good deal.

-Eric
