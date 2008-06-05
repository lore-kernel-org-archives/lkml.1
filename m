Return-Path: <linux-kernel-owner+w=401wt.eu-S1757354AbYFEVsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354AbYFEVsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 17:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbYFEVsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 17:48:07 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57765 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752587AbYFEVsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 17:48:06 -0400
Date: Thu, 5 Jun 2008 16:47:59 -0500
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: mingo@elte.hu, peterz@infradead.org, menage@google.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] sched: prevent bound kthreads from changing
 cpus_allowed
Message-Id: <20080605164759.24ce0c83.pj@sgi.com>
In-Reply-To: <alpine.DEB.1.10.0806051255500.31157@chino.kir.corp.google.com>
References: <alpine.DEB.1.10.0806051255500.31157@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok - looks good to me.  (I too have shot my foot off
moving tasks that shouldn't be moved - thanks.)

Reviewed-by: Paul Jackson <pj@sgi.com>

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
