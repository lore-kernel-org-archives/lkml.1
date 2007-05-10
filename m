Return-Path: <linux-kernel-owner+w=401wt.eu-S1762412AbXEJOPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762412AbXEJOPK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 10:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757880AbXEJOO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 10:14:59 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:41093 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752880AbXEJOO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 10:14:58 -0400
Date: Thu, 10 May 2007 10:14:58 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Hellwig <hch@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 07/10] Linux Kernel Markers - Documentation
Message-ID: <20070510141458.GG22424@Krystal>
References: <20070510015555.973107048@polymtl.ca> <20070510020917.172554217@polymtl.ca> <20070510065847.GE8019@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070510065847.GE8019@infradead.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 10:13:39 up 97 days,  4:20,  5 users,  load average: 2.10, 2.14, 2.22
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Hellwig (hch@infradead.org) wrote:
> On Wed, May 09, 2007 at 09:56:02PM -0400, Mathieu Desnoyers wrote:
> > Here is some documentation explaining what is/how to use the Linux
> > Kernel Markers.
> 
> Please remove all references to out of tree code from the kernel documentation.
> 

Hrm, I see.. you are objecting to mentioning of "LTTng, LKET, SystemTAP"...
I agree : it belongs to a changelog (which is bounded in time) rather
than to the documentation itself.

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
