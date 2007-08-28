Return-Path: <linux-kernel-owner+w=401wt.eu-S1755984AbXH2RIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbXH2RIB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 13:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbXH2RHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 13:07:52 -0400
Received: from gate.crashing.org ([63.228.1.57]:56923 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346AbXH2RHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 13:07:51 -0400
Subject: Re: [PATCH] Add I/O hypercalls for i386 paravirt
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Zachary Amsden <zach@vmware.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Avi Kivity <avi@qumranet.com>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <46D3C60B.3050605@vmware.com>
References: <46CBC842.4070100@vmware.com>  <46CBCADF.2070400@qumranet.com>
	 <1187763956.6174.48.camel@localhost.localdomain>
	 <1188237281.5972.69.camel@localhost.localdomain>
	 <46D3C60B.3050605@vmware.com>
Content-Type: text/plain
Date: Tue, 28 Aug 2007 13:18:02 +0200
Message-Id: <1188299882.5972.82.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> We have an X driver that does minimal performance costing operations.  
> As we should and will have for our other drivers.

Ok, so you use your own DDX and prevent X vgacrapware to kick in ? Makes
sense.

Ben.


