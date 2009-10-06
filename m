Return-Path: <linux-kernel-owner+w=401wt.eu-S932418AbZJFQlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418AbZJFQlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 12:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932143AbZJFQlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 12:41:36 -0400
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:49439 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932131AbZJFQlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 12:41:35 -0400
From: Frans Pop <elendil@planet.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.32-rc3
Date: Tue, 6 Oct 2009 18:40:56 +0200
User-Agent: KMail/1.9.9
Cc: mingo@elte.hu, hohndel@infradead.org, linux-kernel@vger.kernel.org
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain> <20091006144449.GA23078@elte.hu> <20091006144449.GA23078@elte.hu> <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain>
In-reply-To: <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910061840.57681.elendil@planet.nl>
X-OriginalArrivalTime: 06 Oct 2009 16:40:58.0141 (UTC) FILETIME=[C7EECCD0:01CA46A3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:

>> One option would be to make LOCALVERSION_AUTO compulsory.
> 
> Yes, I could live with that. If you're compiling from a git tree, we
> might as well show the real version.

Not sure I'd like that.Actually pretty sure I'd hate it.
It would completely break the clean mechanism I currently have (described 
in my previous post).

Enabling it by default somehow would be fine with me, but "compulsory" is a 
step to far IMO. Users should always be allowed custom schemes.

Cheers,
FJP
