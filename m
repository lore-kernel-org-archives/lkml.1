Return-Path: <linux-kernel-owner+w=401wt.eu-S1754906AbYIWCfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906AbYIWCfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 22:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753838AbYIWCfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 22:35:00 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:16657 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795AbYIWCe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 22:34:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kHBfsAi2aLgaXrIrb/P8YsfNuB3xezVjLzXnrw9M7YPzNXRDw8c3h87GhKShGDzhDw
         jARqkb+Jm3/B3aOGfgYh7KdTZmk+EWvalft70r3YLtwW53Ysx3Yf+sCyOHpAk8Yx9VuV
         pDcstdImbmCpaKWosNi++N1HSrD6gH+siAiRI=
Message-ID: <86802c440809221934n5998c2f0rcb25b2d250fdc4db@mail.gmail.com>
Date: Mon, 22 Sep 2008 19:34:59 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Chris Li" <lkml@chrisli.org>
Subject: Re: irq 19: nobody cared
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <70318cbf0809221922r4d874ac8v22dc682cbbcb1153@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <70318cbf0809191340t4e9d4caft6656713576cd2084@mail.gmail.com>
	 <86802c440809191457g19e2cbbeo26aa3dff613b057f@mail.gmail.com>
	 <70318cbf0809191532n6ebaa122v7d98815c8a65850b@mail.gmail.com>
	 <86802c440809201435l6fdb7c90u59b6b816efb7f2f6@mail.gmail.com>
	 <70318cbf0809201504i3f9688b1u9692b4534af0627d@mail.gmail.com>
	 <86802c440809201522n5d450832vcbbd58d03a3943d8@mail.gmail.com>
	 <70318cbf0809201621r3f31466paef0586f094d40cf@mail.gmail.com>
	 <70318cbf0809221630s393bd003h230dd442aa386d6f@mail.gmail.com>
	 <86802c440809221832p408d15aan9bdcd3aab54ed80d@mail.gmail.com>
	 <70318cbf0809221922r4d874ac8v22dc682cbbcb1153@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 7:22 PM, Chris Li <lkml@chrisli.org> wrote:
> Which kernel branch? Linus's git tree does not have this option.
>
> Chris
>
> On Mon, Sep 22, 2008 at 6:32 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>>>
>>
>> CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS

tip/master

http://people.redhat.com/mingo/tip.git/readme.txt

YH
