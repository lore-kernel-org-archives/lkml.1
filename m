Return-Path: <linux-kernel-owner+w=401wt.eu-S935071AbXGQRzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935071AbXGQRzb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 13:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763194AbXGQRzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 13:55:15 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:57212 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760811AbXGQRzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 13:55:13 -0400
Date: Tue, 17 Jul 2007 10:55:09 -0700
From: Paul Jackson <pj@sgi.com>
To: "Paul (=?ISO-8859-1?Q?=5F=5F=5F=5F=5F=5F?=) Menage" 
	<menage@google.com>
Cc: balbir@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com, xemul@sw.ru,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       akpm@linux-foundation.org
Subject: Re: Containers: css_put() dilemma
Message-Id: <20070717105509.95d72b35.pj@sgi.com>
In-Reply-To: <6599ad830707171044u38c0a940r12d2bc80b475ead4@mail.gmail.com>
References: <469BBE00.8000709@linux.vnet.ibm.com>
	<6599ad830707161203o7f148c75p52e77d4be3ace487@mail.gmail.com>
	<469C2792.6050009@linux.vnet.ibm.com>
	<6599ad830707161935n69776f1t98292fc9990f4766@mail.gmail.com>
	<20070717070031.GA22410@linux.vnet.ibm.com>
	<6599ad830707170018p180cb7dfr53e609fd0b186e30@mail.gmail.com>
	<469C99D1.7090807@linux.vnet.ibm.com>
	<6599ad830707170849v11fe8cecs6d172cd38d247e09@mail.gmail.com>
	<469CFF2B.1080702@linux.vnet.ibm.com>
	<6599ad830707171044u38c0a940r12d2bc80b475ead4@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul M wrote:
> In fact, that's exactly what the release agent
> patch already does.

I'm feeling lazy ;)  What's the Subject of that
patch, for my easy searching?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
