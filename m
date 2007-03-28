Return-Path: <linux-kernel-owner+w=401wt.eu-S965686AbXC1TId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965686AbXC1TId (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 15:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965687AbXC1TId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 15:08:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:39993 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965686AbXC1TId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 15:08:33 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH] x86_64 : vsyscall_gtod_data diet and vgettimeofday() fix
Date: Wed, 28 Mar 2007 20:55:34 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux kernel <linux-kernel@vger.kernel.org>
References: <460AA6E3.50109@cosmosbay.com>
In-Reply-To: <460AA6E3.50109@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703282055.34452.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 March 2007 19:33, Eric Dumazet wrote:
> Hi Andrew
> 
> This patch should be applied after x86_64 : fix vtime() vsyscall

Applied thanks. I noticed this cache efficiency also while changing something
else recently, but didn't have the motivation to really fix it.

-Andi
