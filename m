Return-Path: <linux-kernel-owner+w=401wt.eu-S967253AbXJSW2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967253AbXJSW2e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 18:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbXJSW2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 18:28:23 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:37343 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966779AbXJSW2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 18:28:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=hILqgpkJs7KgmQZgesC6LWzVjZO02IuVweHHehuc6qpdKCGfEjYfBWmkYY8F3/kkspA4c5GBoM934GKmIKWc+duU09CpU3o0RY1G6sAJdm4w+L8ajkUpP/dIOZc0YvWqdQ31LTN+Ib0AwLWNHYo6ucRtvZJl2FTZFfOt+FM4mjw=
Message-ID: <47192E7D.7080409@googlemail.com>
Date: Sat, 20 Oct 2007 00:23:57 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071004)
MIME-Version: 1.0
To: Jiri Kosina <jikos@jikos.cz>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Gabriel C <crazy@pimpmylinux.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: some kernel headers broken in current git ?
References: <4719174A.7020004@googlemail.com> <Pine.LNX.4.64.0710192307320.18815@twin.jikos.cz> <47191F6C.2040801@googlemail.com>
In-Reply-To: <47191F6C.2040801@googlemail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
> Jiri Kosina wrote: 
>> Trying 'make mrproper' first has high chances of fixing this I'd guess.
> 
> Is what I did before latest pull. 
> 
> Maybe this whole tree got broken. I'll try a fresh one and report back.
> 


I get the same on fresh cloned git tree

#-- git rev-parse --verify HEAD
c4ec20717313daafba59225f812db89595952b83


Regards,

Gabriel
