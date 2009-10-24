Return-Path: <linux-kernel-owner+w=401wt.eu-S1752182AbZJXDOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182AbZJXDOA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 23:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbZJXDOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 23:14:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38979
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751967AbZJXDN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 23:13:59 -0400
Date: Fri, 23 Oct 2009 20:14:22 -0700 (PDT)
Message-Id: <20091023.201422.193699039.davem@davemloft.net>
To: compudj@krystal.dyndns.org
Cc: linux-kernel@vger.kernel.org, dominique.toupin@ericsson.com,
       michel.dagenais@polymtl.ca, pierre-marc.fournier@polymtl.ca
Subject: Re: Relicensing immediate values to Dual LGPL v2.1/GPL v2, headers
 to Dual BSD/GPL
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091023162600.GA4495@Krystal>
References: <20091023162600.GA4495@Krystal>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Date: Fri, 23 Oct 2009 12:26:00 -0400

> In the LTTng tree, I would like to re-license
> arch/sparc/kernel/immediate.c from GPL to:
> 
>  * Dual LGPL v2.1/GPL v2 license.
> 
> And re-license arch/sparc/include/asm/immediate.h to:
> 
>   * Dual BSD/GPL v2 license.
> 
> The goal is to allow sharing code between the kernel tracer and UST
> (User-Space Tracer) project, which is a LGPL v2.1 library. Immediate
> values headers might need to be included by proprietary or BSD
> applications, hence the dual BSD/GPL v2 license for this header.
> 
> Do I have your OK to do this ?

No problem.
