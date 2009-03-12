Return-Path: <linux-kernel-owner+w=401wt.eu-S1756884AbZCLOxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884AbZCLOxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 10:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754494AbZCLOxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 10:53:45 -0400
Received: from mail-fx0-f176.google.com ([209.85.220.176]:47806 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214AbZCLOxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 10:53:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=AmSZevX/ooPVMRyqU3GzIQH1/MEQbjMzOeaFDKpUA/TX+Y1C6JdIKMPUCbRgQFWisO
         zRq+xRdwgyTnojTt6Df1mwfkgJ4j7LPneRL4ffjOiB1YPra8yzi5whTeL07javQZU5nh
         7OFdHvvpoVk2VWOlUD3qM7XqdNk7SIC3XhLoI=
MIME-Version: 1.0
In-Reply-To: <49B8DDDF.8080708@cateee.net>
References: <2d05c4580903090243k6cf73ee9ubb6c4fccf0f07a2f@mail.gmail.com>
	 <20090309141655.GA24213@silver.sucs.org>
	 <20090309081109.376f7a7e@infradead.org>
	 <20090309153449.GB24213@silver.sucs.org>
	 <20090309095330.30278385@infradead.org> <49B8DDDF.8080708@cateee.net>
Date: Thu, 12 Mar 2009 15:53:40 +0100
Message-ID: <2d05c4580903120753l4111fb42w760f3d448c0c301c@mail.gmail.com>
Subject: Re: Linux* Processor Microcode Data File
From: Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>
To: "Giacomo A. Catenazzi" <cate@cateee.net>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I agree with you 100%, and I think that GRUB should do that loading and new
kernel version should supply newest and tested microcode.
