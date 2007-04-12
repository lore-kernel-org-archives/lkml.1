Return-Path: <linux-kernel-owner+w=401wt.eu-S1161430AbXDLBSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161430AbXDLBSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 21:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161436AbXDLBSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 21:18:46 -0400
Received: from terminus.zytor.com ([192.83.249.54]:34159 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161430AbXDLBSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 21:18:46 -0400
Message-ID: <461D88F1.8090407@zytor.com>
Date: Wed, 11 Apr 2007 18:18:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Carlo Florendo <subscribermail@gmail.com>
CC: JanuGerman <doublemalam@yahoo.co.uk>,
       linuxkernel <linux-kernel@vger.kernel.org>
Subject: Re: Security computation within Linux kernel
References: <20070408143653.97346.qmail@web86905.mail.ukl.yahoo.com> <461D871B.6070901@gmail.com>
In-Reply-To: <461D871B.6070901@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Carlo Florendo wrote:
> 
> IIRC, The kernel does some encryption functions, involving TCP, NFS, and 
> IPsec since all these are part of the kernel itself.
> 

Yes, but key management is done in userspace.

	-hpa
