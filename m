Return-Path: <linux-kernel-owner+w=401wt.eu-S1754283AbZFAQqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbZFAQqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 12:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbZFAQqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 12:46:12 -0400
Received: from relay2.sgi.com ([192.48.179.30]:44127 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751661AbZFAQqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 12:46:12 -0400
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alex Samad <alex@samad.com.au>, Dave Chinner <david@fromorbit.com>,
       xfs mailing list <xfs@oss.sgi.com>
Message-Id: <36C1B891-5BC9-4149-AF22-58BC22AD7A3A@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <PkPeJtNB3KO.A._pF.ZVbIKB@chimera>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [Bug #13375] Kernel crash with 2.6.29 + nfs + xfs (radix-tree)
Date: Mon, 1 Jun 2009 11:46:12 -0500
References: <THxQaUP0K2D.A.QkF.UVbIKB@chimera> <PkPeJtNB3KO.A._pF.ZVbIKB@chimera>
X-Mailer: Apple Mail (2.926)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc'ing the xfs mailing list]

On May 30, 2009, at 2:55 PM, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.28 and 2.6.29.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.28 and 2.6.29.  Please verify if it still  
> should
> be listed and let me know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13375
> Subject		: Kernel crash with 2.6.29 + nfs + xfs (radix-tree)
> Submitter	: Alex Samad <alex@samad.com.au>
> Date		: 2009-05-20 0:37 (11 days old)
> References	: http://marc.info/?l=linux-kernel&m=124278675503699&w=4
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

