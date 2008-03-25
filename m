Return-Path: <linux-kernel-owner+w=401wt.eu-S1757199AbYCYCiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199AbYCYCiT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 22:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754502AbYCYCiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 22:38:05 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:52265 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894AbYCYCiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 22:38:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=HX1VWanCh+8ehnn9JeSPx1iA7T9FMCEXlSSQdN0MzwKwZb5VrMxk62e3KmMdgZ8XJipzP4vQexaYbl8pIJvE4N1T/l/ufoscpv+AWuTCLCPigsr9z/gGQ9gdz3jmlYst0/a8PqOlUdav+FN+43856lLz3HBbDFjZpdnY9bbt8NM=
Message-ID: <47E86580.6050206@gmail.com>
Date: Tue, 25 Mar 2008 11:37:52 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Mikael Pettersson <mikpe@it.uu.se>, kurt@roeckx.be,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.25-rc6] sata_promise: fix hardreset hotplug events,
 take 2
References: <200803221421.m2MEL1oY021558@harpo.it.uu.se> <18406.38445.717175.664615@harpo.it.uu.se> <47E70FB4.4010802@gmail.com> <47E86442.8030708@garzik.org>
In-Reply-To: <47E86442.8030708@garzik.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Tejun Heo wrote:
>> Acked-by: Tejun Heo <htejun@gmail.com>
>>
>> Jeff, do you want to merge this first?  If so, I'll update the
>> prefer-hardreset and cleanup-sht-ops patchsets; otherwise, I'll massage
>> this patch a bit so that it fits on top of those two patchsets.
> 
> 
> I just merged it into #upstream-fixes (answering your question)...  what
> is your preferred method of sync'ing at this point?

Heh... me refreshing the patchset again.  Doing it right now.

-- 
tejun
