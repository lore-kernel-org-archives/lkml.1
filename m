Return-Path: <linux-kernel-owner+w=401wt.eu-S1756256AbYHHAPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256AbYHHAPG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 20:15:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753703AbYHHAO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 20:14:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44336 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbYHHAOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 20:14:55 -0400
Message-ID: <489B8F2D.6030104@kernel.org>
Date: Thu, 07 Aug 2008 17:11:25 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Alok Kataria <akataria@vmware.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]Fix broken VMI in 2.6.27-rc..
References: <1218136365.23770.52.camel@alok-dev1> <489B6710.9000604@kernel.org>	 <1218144438.20178.336.camel@bodhitayantram.eng.vmware.com>	 <489B836A.3050209@goop.org> <489B84EF.6050009@kernel.org>	 <489B8948.6060003@goop.org> <489B8A68.10900@kernel.org> <86802c440808071701j4ebdc15u16e8d0e77b945c2f@mail.gmail.com>
In-Reply-To: <86802c440808071701j4ebdc15u16e8d0e77b945c2f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> 
> why not reserving that in e820 table?
> 

Virtual space, not physical space.

	-hpa
