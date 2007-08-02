Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490AbXHBAuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbXHBAuO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 20:50:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753758AbXHBAt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 20:49:59 -0400
Received: from ns2.suse.de ([195.135.220.15]:51527 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753404AbXHBAt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 20:49:58 -0400
From: Neil Brown <neilb@suse.de>
To: Tejun Heo <htejun@gmail.com>
Date: Thu, 2 Aug 2007 10:49:42 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18097.10790.205449.176104@notabene.brown>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 026 of 35] Split any large bios that arrive at __make_request.
In-Reply-To: message from Tejun Heo on Thursday August 2
References: <20070731112539.22428.patches@notabene>
	<1070731021804.25499@suse.de>
	<20070801175636.GJ13674@htj.dyndns.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday August 2, htejun@gmail.com wrote:
> Hmmm... Patches don't apply beyond this one.  I'm applying against
> clean 2.6.23-rc1-mm1 grabbed using ketchup.
> 

So do you mean 027 doesn't apply, or that 028 doesn't apply next?

It is possible that you missed 027.  It originally has 3 consecutive
Xs in the subject line, so vger.kernel.org bounced it.
I re-sent it, but it would have had a different References header and
the might not appear in the same thread.

If you confirm that 027 isn't applying, I'll track down what happened.

Thanks,
NeilBrown
