Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083Ab0CDUsX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 15:48:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64159 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756390Ab0CDUsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 15:48:22 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, wylda@volny.cz, gregkh@suse.de,
       jkosina@suse.cz, Linus Torvalds <torvalds@linux-foundation.org>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pid_ns: zap_pid_ns_processes: use SEND_SIG_NOINFO instead
	of force_sig()
In-Reply-To: Oleg Nesterov's message of  Wednesday, 3 March 2010 21:26:50 +0100 <20100303202650.GA15521@redhat.com>
References: <alpine.LFD.2.00.1003021136400.3616@localhost.localdomain>
	<20100302201646.GA10734@redhat.com>
	<alpine.LFD.2.00.1003021223060.3616@localhost.localdomain>
	<20100303013227.4FFDE89EB@magilla.sf.frob.com>
	<alpine.LFD.2.00.1003021740560.3616@localhost.localdomain>
	<20100303112343.B89802F@magilla.sf.frob.com>
	<alpine.LFD.2.00.1003030930100.3627@localhost.localdomain>
	<20100303184412.GA7816@redhat.com>
	<alpine.LFD.2.00.1003031053050.3599@localhost.localdomain>
	<20100303193003.GA10734@redhat.com>
	<20100303202650.GA15521@redhat.com>
X-Shopping-List: (1) Cooking basket invasions
   (2) Magnificent diagnostic compulsion holidays
   (3) Lucky photogenic riot communions
   (4) Enchained detection pianos
Message-Id: <20100304204807.A5C86187@magilla.sf.frob.com>
Date: Thu,  4 Mar 2010 12:48:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>
