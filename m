Return-Path: <linux-kernel-owner+w=401wt.eu-S1756938AbZCBVlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938AbZCBVlu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 16:41:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753884AbZCBVlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 16:41:42 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:52481 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbZCBVll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 16:41:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=DWlyidnI8OJQ0lNPmQOp9lzUqN9cLzcpJESDQglcUNOuYxO9wotI+oenFHGhgY1Vk2
         zsqezsvi932kz6WNCenU0dNURTwVVSkLdY6jOvmucGg0nRRydvHjGm/kauqv2yh5pDWJ
         y8UnLTonqz69phNvZn9fGnRu9jqZjoy8f/mbI=
Subject: Re: [RFC PATCH 0/6] module, kbuild: Faster boot with custom kernel.
From: Andreas Robinson <andr345@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Rusty Russell <rusty@rustcorp.com.au>,
       sam@ravnborg.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090302102703.50aaf724@infradead.org>
References: <1234722028-8110-1-git-send-email-andr345@gmail.com>
	 <ac3eb2510902170353ia62a630nbe5cf059ca7d616e@mail.gmail.com>
	 <200902181528.29697.rusty@rustcorp.com.au>
	 <ac3eb2510902180115o4690a335n129e4df695540de0@mail.gmail.com>
	 <1234952753.10531.48.camel@andreas-laptop>
	 <cc43514a0902191637h5a9680c5id95f7d6c32cca472@mail.gmail.com>
	 <ac3eb2510902191755i391d4defnc5a514f4525ec6cf@mail.gmail.com>
	 <1235216636.7025.1023.camel@andreas-laptop>
	 <1236004353.10055.49.camel@andreas-laptop>
	 <20090302082003.1bb7bdc5@infradead.org>
	 <ac3eb2510903020829s7c876a96y7eb5568eeb9921fd@mail.gmail.com>
	 <20090302102703.50aaf724@infradead.org>
Content-Type: text/plain
Date: Mon, 02 Mar 2009 22:41:36 +0100
Message-Id: <1236030096.6691.3.camel@andreas-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> there is some sata level enabling needed depending on the system;
> I'd love to see the bootgraph (scripts/bootgraph.pl) for the boot;
> that shows exactly what happens when and for how long.

Hmm, I was going to send you a reply tonight, but it seems I've run out
of time. I'll get back to you as soon as possible, probably tomorrow.

Cheers,
Andreas


