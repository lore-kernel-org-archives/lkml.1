Return-Path: <linux-kernel-owner+w=401wt.eu-S1757407AbZBSUzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407AbZBSUzc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 15:55:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbZBSUzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 15:55:21 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:44430 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbZBSUzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 15:55:19 -0500
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <m1ocx5ve8o.fsf@fess.ebiederm.org>
	<20090219120333.af992d9e.akpm@linux-foundation.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 19 Feb 2009 12:55:37 -0800
In-Reply-To: <20090219120333.af992d9e.akpm@linux-foundation.org> (Andrew Morton's message of "Thu\, 19 Feb 2009 12\:03\:33 -0800")
Message-ID: <m163j61706.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0002]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] pcie_portdriver: FIX: pcie_port_device_remove
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

>
> There are large-scale and conflicting changes to this file in linux-next.
>
> If we want to jam this fix into 2.6.29 (and it looks like something we
> want) then this will trash the linux-next changes.  It will cause me
> grief, and will cause Stephen grief unless the pci tree is suitably
> changed, which will cause Jesse grief. Either way: grief.

Ugh.

I had better have a good hard look at linux-next.  I tried to ask earlier about
ongoing working but I didn't hear anything.

Eric

