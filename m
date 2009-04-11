Return-Path: <linux-kernel-owner+w=401wt.eu-S1758609AbZDKSgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609AbZDKSgg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 14:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbZDKSg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 14:36:28 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:52935 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbZDKSg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 14:36:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gq48ueNwvyQjacMmLH6YwoeuwF3mfHvjqvTXW7M2jXUOvNiNoR6amQDzZngo74ReH0
         bFj/y6iTK2Xhm6QEh4XBZsrhM+SsgD/2WhHNkqFdr8OG1fGn5k+bsALZeaADdCQKx9oj
         QQNCbnWfhvOUB4npaf+fI0Mk1XU9cOTVC1KuQ=
MIME-Version: 1.0
In-Reply-To: <3d2f29dc0904081505l4e0203a0q25144d200164c82a@mail.gmail.com>
References: <3d2f29dc0904071551xadea34ajd2c177380ced4fef@mail.gmail.com>
	 <49DCDF1F.5050805@xandros.com>
	 <3d2f29dc0904081505l4e0203a0q25144d200164c82a@mail.gmail.com>
Date: Sat, 11 Apr 2009 14:36:26 -0400
Message-ID: <3d2f29dc0904111136q13e6104at657c8148a2765f71@mail.gmail.com>
Subject: Re: Weird freezes with 2.6.28/29
From: Chris Howie <cdhowie@gmail.com>
To: Woody Suwalski <woodys@xandros.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 8, 2009 at 6:05 PM, Chris Howie <cdhowie@gmail.com> wrote:
> On Wed, Apr 8, 2009 at 1:30 PM, Woody Suwalski <woodys@xandros.com> wrote:
>> I am getting similar problem on Dell 4x00 laptops caused by loading
>> processor.ko.
>> If I use nocst=1 option, systems are OK.
>
> Thanks, this has eliminated the second freeze (where I must hold down
> a key to allow boot to proceed) but I still have to hit the power
> button to get the initial boot going.

Hmm, it turns out it didn't actually fix it.  The hold-a-key-down
freeze doesn't happen every time and it didn't for a while after I
added this option, but it started again this morning.

-- 
Chris Howie
http://www.chrishowie.com
http://en.wikipedia.org/wiki/User:Crazycomputers
