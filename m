Return-Path: <linux-kernel-owner+w=401wt.eu-S1754428AbZESQ4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbZESQ4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 12:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbZESQ4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 12:56:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38187 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbZESQ4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 12:56:33 -0400
Message-ID: <4A12E122.1020009@kernel.org>
Date: Tue, 19 May 2009 09:41:06 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Robert Richter <robert.richter@amd.com>, Dave Jones <davej@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 3/10 -tip] x86: Add cpufeatures for Advanced Power Management
References: <1242142530.2547.11.camel@ht.satnam>	 <1242142623.2547.13.camel@ht.satnam>  <1242142692.2547.15.camel@ht.satnam>	 <1242142753.2547.16.camel@ht.satnam> <1242155190.2492.73.camel@ht.satnam>	 <alpine.LFD.2.00.0905122219420.3561@localhost.localdomain>	 <1242395277.3082.24.camel@localhost.localdomain>	 <alpine.LFD.2.00.0905171415150.3516@localhost.localdomain> <1242745272.3169.13.camel@localhost.localdomain>
In-Reply-To: <1242745272.3169.13.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
> 
> Peter, Ingo:
> Do you think we need to arrange x86_capability in some order, currently
> we are using x86_capability numbering in random order.
> 

No.

	-hpa
