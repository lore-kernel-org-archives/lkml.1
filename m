Return-Path: <linux-kernel-owner+w=401wt.eu-S1757571AbYBHWPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571AbYBHWPm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751191AbYBHWPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:15:34 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:26950 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbYBHWPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:15:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=UirkMWbcHGdeVQ2yN/1i0uS5iJfpOP5E8VrqPTmHfkWFhmXdCduBBoW1kDr4HV/LokoGYorSkDaIsX32JEtG5MIo9kkM572Aq2+gY4JfKif6X9FwzzHkOt/AYeOZVnsy/Hwf2vAFCla2LEw60DdVL3CkU00U/AU1X9fB8OQ9kpo=
Message-ID: <47ACD481.3040801@gmail.com>
Date: Fri, 08 Feb 2008 23:15:29 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 1/1] tty: BKL pushdown fix
References: <20080208154208.0efd6885@core>	<1202497487-32550-1-git-send-email-jirislaby@gmail.com>	<20080208133530.0e453c50.akpm@linux-foundation.org>	<47ACCBD4.1000502@gmail.com> <20080208141133.7a739f4f.akpm@linux-foundation.org>
In-Reply-To: <20080208141133.7a739f4f.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2008 11:11 PM, Andrew Morton wrote:
> On Fri, 08 Feb 2008 22:38:28 +0100
> Jiri Slaby <jirislaby@gmail.com> wrote:
>> Note that it isn't only whitespace fixes in the patch.
> 
> Well no, I didn't note that.  The absence of any changelog led me to
> believe that it was the obvious and trivial change which it appeared to be.
> 
>> I have one more -fix.
> 
> And that one had zero description either.
> 
> Please, it only takes 30 seconds.

Well, I though -fix descriptions go to /dev/null after folding it to the parent. 
No problem to comment them too. Next time. Thanks.
