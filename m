Return-Path: <linux-kernel-owner+w=401wt.eu-S1756835AbYH3Uig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835AbYH3Uig (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 16:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbYH3Ui1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 16:38:27 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:50288 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbYH3Ui0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 16:38:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=BX4oHzuj4xRLNrcSTr46FmXwjgXhQHdtQW+SNo+Ya8erv/BuInA0+ymu2BbIZKBDyt
         1isL/btEI1/nkW1jqcH4/nAhVzls6uhvGCdsBMS75CQfqyJV7KV/Qk2XeLu1hC/aIcWL
         e9as6a7akOktmui7w6yUliGEIcbsgxfY/7rJ0=
Message-ID: <86802c440808301338h59a5338rabe9e64560b55476@mail.gmail.com>
Date: Sat, 30 Aug 2008 13:38:25 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Tejun Heo" <htejun@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "David Witbrodt" <dawitbro@sbcglobal.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Kernel Testers" <kernel-testers@vger.kernel.org>
In-Reply-To: <86802c440808301314t525d1b75r9afcc73857cf5c79@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>
	 <200808292157.24179.rjw@sisk.pl>
	 <alpine.LFD.1.10.0808291434110.3300@nehalem.linux-foundation.org>
	 <200808300030.32905.rjw@sisk.pl>
	 <alpine.LFD.1.10.0808301012060.3290@nehalem.linux-foundation.org>
	 <86802c440808301107n4561e815ldf53183c92a7bc93@mail.gmail.com>
	 <alpine.LFD.1.10.0808301141590.3290@nehalem.linux-foundation.org>
	 <86802c440808301210u6db1b4e7p4036bdc95db1a601@mail.gmail.com>
	 <alpine.LFD.1.10.0808301214310.3290@nehalem.linux-foundation.org>
	 <86802c440808301314t525d1b75r9afcc73857cf5c79@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

please check

[PATCH] x86: split e820 reserved entries record to late v4
[PATCH] x86: split e820 reserved entries record to late v4 - fix v6

YH
