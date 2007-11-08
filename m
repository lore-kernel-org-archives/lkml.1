Return-Path: <linux-kernel-owner+w=401wt.eu-S1759393AbXKHAOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759393AbXKHAOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 19:14:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755034AbXKHAON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 19:14:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbXKHAON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 19:14:13 -0500
Message-ID: <473254BF.3040701@redhat.com>
Date: Wed, 07 Nov 2007 19:13:51 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Jeff Dike <jdike@addtoit.com>, Andrew Morton <akpm@osdl.org>,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       Chuck Ebbert <76306.1226@compuserve.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86 - 32-bit ptrace emulation mishandles 6th arg
References: <20071107154839.GA5981@c2.user-mode-linux.org> <20071107211222.B95634D0564@magilla.localdomain>
In-Reply-To: <20071107211222.B95634D0564@magilla.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2007 04:12 PM, Roland McGrath wrote:
> Sure has my ACK.  
> I never really understood why my old patch was not taken 2.5 years ago.
> 
> 

I forget the details, but I had to make some kind of trivial change
to make it work in some corner cases.
