Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbYIWCWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbYIWCWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 22:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754218AbYIWCWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 22:22:32 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:14192 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993AbYIWCWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 22:22:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=YLLOz3a54qQXYq+dMud/rIyyENeyiRYR3j8wls4dZEqcT826qa02hXRO4GXyn4QUSl
         ZttjLrH5v9wiU67NiRhNospw0w6KRNVvuKfxzmbHUTT92iPYiIMnZEQeu3fc5qe9U5hq
         Xi4O/GCrsouAUR7ZgGVb34yNs6DMyyZZCBuKo=
Message-ID: <70318cbf0809221922r4d874ac8v22dc682cbbcb1153@mail.gmail.com>
Date: Mon, 22 Sep 2008 19:22:31 -0700
From: "Chris Li" <lkml@chrisli.org>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: irq 19: nobody cared
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <86802c440809221832p408d15aan9bdcd3aab54ed80d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <70318cbf0809191340t4e9d4caft6656713576cd2084@mail.gmail.com>
	 <70318cbf0809191413v70c49eccq9ed16ae50864a1a5@mail.gmail.com>
	 <86802c440809191457g19e2cbbeo26aa3dff613b057f@mail.gmail.com>
	 <70318cbf0809191532n6ebaa122v7d98815c8a65850b@mail.gmail.com>
	 <86802c440809201435l6fdb7c90u59b6b816efb7f2f6@mail.gmail.com>
	 <70318cbf0809201504i3f9688b1u9692b4534af0627d@mail.gmail.com>
	 <86802c440809201522n5d450832vcbbd58d03a3943d8@mail.gmail.com>
	 <70318cbf0809201621r3f31466paef0586f094d40cf@mail.gmail.com>
	 <70318cbf0809221630s393bd003h230dd442aa386d6f@mail.gmail.com>
	 <86802c440809221832p408d15aan9bdcd3aab54ed80d@mail.gmail.com>
X-Google-Sender-Auth: c6fa32661fae744a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Which kernel branch? Linus's git tree does not have this option.

Chris

On Mon, Sep 22, 2008 at 6:32 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>>
>
> CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS
>
