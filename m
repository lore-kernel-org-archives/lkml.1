Return-Path: <linux-kernel-owner+w=401wt.eu-S1765244AbYBNFCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765244AbYBNFCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 00:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750716AbYBNFCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 00:02:10 -0500
Received: from ti-out-0910.google.com ([209.85.142.187]:64790 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbYBNFCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 00:02:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=m2XwYRE8v3UhPVcBArTUo83Ezx97lQz9MWcGHNjKbU6+yY2ALcNcfqUgrDfKMJHKUKWDij7j3MsdnYxe34yJw/S60MyYEjNhUGSYFBUHpOfirMrV4cJ6V5/08e8NjLJLLL8OcDAF6G552cWrI36MV+GhLVy4wmCcRNfG6/jwOV4=
Message-ID: <df9815e70802132102v7eb7d8e9k4d6b21ffa6325d0d@mail.gmail.com>
Date: Thu, 14 Feb 2008 13:02:06 +0800
From: "Jike Song" <albcamus@gmail.com>
To: "Max Krasnyansky" <maxk@qualcomm.com>
Subject: Re: Module loading/unloading and "The Stop Machine"
Cc: rusty@rustcorp.com.au, "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <47ABC08C.8010101@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47ABC08C.8010101@qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/8/08, Max Krasnyansky <maxk@qualcomm.com> wrote:
> Hi Rusty,
>
> I was hopping you could answer a couple of questions about module loading/unloading
> and the stop machine.

I'm curious to know why it is called `stop machine', which is a queer
name without any relationship with its function.

Regards,
Jike
