Return-Path: <linux-kernel-owner+w=401wt.eu-S933022AbYBHAGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933022AbYBHAGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 19:06:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758108AbYBHAG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 19:06:27 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757263AbYBHAG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 19:06:26 -0500
Message-ID: <47AB9CF3.9090102@redhat.com>
Date: Thu, 07 Feb 2008 19:06:11 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: Re: [PATCH] x86_64: make traps on 'iret' be debuggable in user	space
References: <20080205075137.617012701A8@magilla.localdomain>	<20080205080149.GA16929@elte.hu>	<20080205081506.655CB2701A8@magilla.localdomain>	<47AB6652.3010600@redhat.com>	<20080207203032.5BF392701AB@magilla.localdomain>	<47AB9416.2030508@redhat.com> <20080208000014.416682701AC@magilla.localdomain>
In-Reply-To: <20080208000014.416682701AC@magilla.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2008 07:00 PM, Roland McGrath wrote:
> It sure didn't look to me like paravirt probably worked.  But what do I know?
> 

I said "if" it worked you probably would have broken it. :)
