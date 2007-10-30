Return-Path: <linux-kernel-owner+w=401wt.eu-S1755964AbXJ3PKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbXJ3PKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 11:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753521AbXJ3PKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 11:10:11 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:58191 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbXJ3PKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 11:10:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NoA8vpKUWeHaVsmFZcn9jjF3l3uH4u+4yzUKWXEwPk7aNKrJh1CsjJst/y+Phb+BosM5MuPPdQPktlNstyMl50dNwu6ANARrNVeLdQbmeZbol/Z0xJ7bpYLbpcO3jZcE4PTcMRKyCzcXoItDY2FpXGoAm054B153IdHXZIfFUwU=
Message-ID: <b1c6420f0710300810g1dbf8142j4c515a9baab4207a@mail.gmail.com>
Date: Wed, 31 Oct 2007 00:10:07 +0900
From: "Suzuki Takashi" <suzuki.takashi@gmail.com>
To: "David Howells" <dhowells@redhat.com>
Subject: Re: [Linux-am33-list] [PATCH 0/2] MN10300: Add the MN10300 architecture to Linux kernel [try #2]
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-am33-list@redhat.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <15631.1193753689@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071029122759.2846.83510.stgit@warthog.procyon.org.uk>
	 <b1c6420f0710300557j57cfc554m458adc7dbeeed610@mail.gmail.com>
	 <15631.1193753689@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/07, David Howells <dhowells@redhat.com> wrote:
> > Why don't you use `am33' for the arch name?
>
> History and the fact that 'mn10300' is what MEI called their arch when they
> originally gave us (RH) their kernel.  There are kernels already out there
> running on consumer devices for which it is the mn10300 arch.

I see.
But the arch name change does not affect running kernels on consumer devices.
And it wouldn't have so much impact on developers.
Drastic changes in the directory and file structures will have
a much greater impact than that.

This submission is a good chance for the new arch name.
New contributors cannot recognize the am33 glibc is for the mn10300 Linux.


-- 
Suzuki Takashi
Japan
