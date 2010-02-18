Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab0BRVR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 16:17:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553Ab0BRVR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 16:17:58 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
X-Fcc: ~/Mail/linus
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Michael Stefaniuc <mstefani@redhat.com>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Maneesh Soni <maneesh@linux.vnet.ibm.com>,
       Alexandre Julliard <julliard@winehq.org>,
       "Rafael J . Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH 1/2] hw-breakpoints: Accept breakpoints on NULL address
In-Reply-To: Frederic Weisbecker's message of  Thursday, 18 February 2010 19:00:00 +0100 <1266516001-7753-2-git-send-regression-fweisbec@gmail.com>
References: <4B7881AC.5070209@redhat.com>
	<1266516001-7753-2-git-send-regression-fweisbec@gmail.com>
X-Zippy-Says: RELATIVES!!
Message-Id: <20100218211659.9C06E4F7@magilla.sf.frob.com>
Date: Thu, 18 Feb 2010 13:16:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setting a watchpoint on address 0 seems like an entirely reasonable thing
to do.  This change looks right to me.

Thanks,
Roland
