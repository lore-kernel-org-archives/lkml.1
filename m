Return-Path: <linux-kernel-owner+w=401wt.eu-S1754568AbYITWW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbYITWW1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 18:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbYITWWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 18:22:18 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:16869 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbYITWWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 18:22:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=NQx6OS95kQZcAjKjSxmRv0cMNB0Ed8FggHEgdSCVXijjeEj4f9lQ8GX+xE1hokP8aQ
         8qdCAi08bGET9LMCA04FaSb5KWKrKaYzfOuiYbnrDlfDspsOBiJAEWLaQ51MHuEamPZE
         APb3yjI0GPrBo7nlkvcNdHCShAi3yLfQ8vf7w=
Message-ID: <86802c440809201522n5d450832vcbbd58d03a3943d8@mail.gmail.com>
Date: Sat, 20 Sep 2008 15:22:16 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Chris Li" <lkml@chrisli.org>
Subject: Re: irq 19: nobody cared
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <70318cbf0809201504i3f9688b1u9692b4534af0627d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <70318cbf0809191340t4e9d4caft6656713576cd2084@mail.gmail.com>
	 <86802c440809191350h21327c76l55d2134d7667f5d0@mail.gmail.com>
	 <70318cbf0809191413v70c49eccq9ed16ae50864a1a5@mail.gmail.com>
	 <86802c440809191457g19e2cbbeo26aa3dff613b057f@mail.gmail.com>
	 <70318cbf0809191532n6ebaa122v7d98815c8a65850b@mail.gmail.com>
	 <86802c440809201435l6fdb7c90u59b6b816efb7f2f6@mail.gmail.com>
	 <70318cbf0809201504i3f9688b1u9692b4534af0627d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2008 at 3:04 PM, Chris Li <lkml@chrisli.org> wrote:
> On Sat, Sep 20, 2008 at 2:35 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>>
>> please apply attached patch and boot with pci=dump
>>
>
> Attached dmesg.
>
could be dsdt irq routing table is wrong.

can you boot with pci=routeirq ?

YH
