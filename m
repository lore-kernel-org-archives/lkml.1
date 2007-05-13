Return-Path: <linux-kernel-owner+w=401wt.eu-S1758235AbXEMFxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235AbXEMFxX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 01:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757653AbXEMFxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 01:53:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:33653 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757346AbXEMFxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 01:53:03 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [PATCH]x86_64: build and use GDT on copied compressed kernel
Date: Sun, 13 May 2007 07:52:55 +0200
User-Agent: KMail/1.9.6
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Vivek Goyal" <vgoyal@in.ibm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       yinghai.lu@sun.com
References: <86802c440705122233y327756e7te534199f46b2059d@mail.gmail.com>
In-Reply-To: <86802c440705122233y327756e7te534199f46b2059d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705130752.56041.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 13 May 2007 07:33:14 Yinghai Lu wrote:
> please check the patch.

Can you please give a little more description on why you think the patch
is needed? Also we need a Signed-off-by line.

Thanks,
-Andi
