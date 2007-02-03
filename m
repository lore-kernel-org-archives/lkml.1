Return-Path: <linux-kernel-owner+w=401wt.eu-S1946428AbXBCJ60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946428AbXBCJ60 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 04:58:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946426AbXBCJ60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 04:58:26 -0500
Received: from mx1.suse.de ([195.135.220.2]:46157 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946425AbXBCJ6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 04:58:25 -0500
From: Andi Kleen <ak@suse.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 1/2] x86_64 irq: Simplfy __assign_irq_vector
Date: Sat, 3 Feb 2007 10:50:22 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       "Lu, Yinghai" <yinghai.lu@amd.com>,
       "Luigi Genoni" <luigi.genoni@pirelli.com>, Ingo Molnar <mingo@elte.hu>,
       Natalie Protasevich <protasnb@gmail.com>
References: <200701221116.13154.luigi.genoni@pirelli.com> <200702021905.39922.luigi.genoni@pirelli.com> <m1zm7w3wvr.fsf_-_@ebiederm.dsl.xmission.com>
In-Reply-To: <m1zm7w3wvr.fsf_-_@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702031050.22214.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 February 2007 01:31, Eric W. Biederman wrote:
> 
> By precomputing old_mask I remove an extra if statement, remove an
> indentation level and make the code slightly easier to read.
> 
> This comes before my bugfix in the next patch so the patch and the
> resulting code stay readable.

Fine for me.

-Andi
