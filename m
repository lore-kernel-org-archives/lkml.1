Return-Path: <linux-kernel-owner+w=401wt.eu-S965698AbXC1TJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965698AbXC1TJG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 15:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965701AbXC1TJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 15:09:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:40004 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965691AbXC1TIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 15:08:39 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: [2.6 patch] i386/x86_64: remove UNEXPECTED_IO_APIC()
Date: Wed, 28 Mar 2007 20:52:29 +0200
User-Agent: KMail/1.9.5
Cc: mingo@redhat.com, discuss@x86-64.org, linux-kernel@vger.kernel.org
References: <20070328121131.GO16477@stusta.de>
In-Reply-To: <20070328121131.GO16477@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703282052.29307.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 March 2007 14:11, Adrian Bunk wrote:
> Many years ago, UNEXPECTED_IO_APIC() contained printk()'s (but nothing more).
> 
> Now that it's completely empty for years, we can as well remove it.

Both patches applied. Thanks
-Andi
