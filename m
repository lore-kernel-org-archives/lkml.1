Return-Path: <linux-kernel-owner+w=401wt.eu-S1752198AbYKNXxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbYKNXxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 18:53:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbYKNXxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 18:53:44 -0500
Received: from rv-out-0506.google.com ([209.85.198.234]:6442 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbYKNXxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 18:53:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=BKDlPrOrNVNIVbUjI9y+MFydz51oTFisINyPR1QfGY0gDJlwPzEFpfSEl+Fp0LSI8O
         hJXqSY1n7QMiV5CxthQZZBuvypNvNl7oDD+FLihMgjdfeF0C8/u6j/8zQns2hpm8EeEF
         S5Vg0P3nBwUnaDtEoR3vW7C38zz0wpuhM4geg=
Message-ID: <3aaafc130811141553oa5f05c8m1615dc37c7e56cd2@mail.gmail.com>
Date: Fri, 14 Nov 2008 18:53:43 -0500
From: "J.R. Mauro" <jrm8005@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for November 14 (staging#2)
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <491E0252.1080801@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081114184021.ed198f4b.sfr@canb.auug.org.au>
	 <20081114101111.f138c2ba.randy.dunlap@oracle.com>
	 <3aaafc130811141413u7d1ee054g9690f1837d96ae6d@mail.gmail.com>
	 <491E0252.1080801@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hrm, I get

linux-next/arch/x86/include/asm/page_64.h:46:2: error: #error
"CONFIG_PHYSICAL_START must be a multiple of 2MB"

And when I ran make I still had to choose options. Maybe it's my
architecture/build chain, but I don't know if I can help with this
one.
