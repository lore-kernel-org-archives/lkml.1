Return-Path: <linux-kernel-owner+w=401wt.eu-S1764264AbXJZRM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764264AbXJZRM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 13:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754378AbXJZRMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 13:12:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35469 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753578AbXJZRMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 13:12:20 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18210.8170.598519.439148@zebedee.pink>
Date: Fri, 26 Oct 2007 18:12:10 +0100
From: Andrew Haley <aph@redhat.com>
To: "Bart Van Assche" <bart.vanassche@gmail.com>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: Is gcc thread-unsafe?
In-Reply-To: <e2e108260710261007n118186b5geb3a48094638497f@mail.gmail.com>
References: <e2e108260710260729x4603211cgb68d7434ce1e54e9@mail.gmail.com>
	<e2e108260710260740k27210c4fu2f75d5fb31ccdccc@mail.gmail.com>
	<alpine.LFD.0.999.0710260814570.30120@woody.linux-foundation.org>
	<alpine.LFD.0.999.0710260917500.30120@woody.linux-foundation.org>
	<e2e108260710261007n118186b5geb3a48094638497f@mail.gmail.com>
X-Mailer: VM 7.19 under Emacs 22.0.93.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bart Van Assche writes:

 > Andrew, do you know whether gcc currently contains any optimization
 > that interchanges the order of accesses to non-volatile variables
 > and function calls ?

It sure does.

Andrew.

-- 
Red Hat UK Ltd, Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, UK
Registered in England and Wales No. 3798903
