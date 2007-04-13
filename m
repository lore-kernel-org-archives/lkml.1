Return-Path: <linux-kernel-owner+w=401wt.eu-S1752022AbXDMG1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022AbXDMG1b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 02:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbXDMG1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 02:27:31 -0400
Received: from terminus.zytor.com ([192.83.249.54]:42199 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbXDMG13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 02:27:29 -0400
Message-ID: <461F2249.9090905@zytor.com>
Date: Thu, 12 Apr 2007 23:25:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Zachary Amsden <zach@vmware.com>, Andrew Morton <akpm@osdl.org>,
       Andi Kleen <ak@muc.de>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>, Hugh Dickins <hugh@veritas.com>,
       David Rientjes <rientjes@google.com>,
       Michel Lespinasse <walken@vmware.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] i386 - pte update optimizations
References: <200704120530.l3C5UGbv022814@zach-dev.vmware.com> <461EDBF1.4080904@zytor.com> <461EE9E5.6060403@vmware.com> <461F1C8E.1010104@cosmosbay.com>
In-Reply-To: <461F1C8E.1010104@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> 
> Is there one processor that benefit from this patch then ?
> 

At least P5 systems should benefit.

	-hpa
