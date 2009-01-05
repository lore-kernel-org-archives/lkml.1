Return-Path: <linux-kernel-owner+w=401wt.eu-S1754942AbZAEN0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942AbZAEN0v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 08:26:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbZAEN0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 08:26:43 -0500
Received: from mercury.realtime.net ([205.238.132.86]:50667 "EHLO
	mercury.realtime.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbZAEN0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 08:26:42 -0500
In-Reply-To: <20090104182441.GA5086@linux.vnet.ibm.com>
References: <5414eaef99b7392a95f6e3488b81dbf7@bga.com> <20090104182441.GA5086@linux.vnet.ibm.com>
Mime-Version: 1.0 (Apple Message framework v624)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <98d6aef17cba9d835d7866745f811dc7@bga.com>
Content-Transfer-Encoding: 7bit
Cc: linux-ppc <linuxppc-dev@ozlabs.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-kernel <linux-kernel@vger.kernel.org>
From: Milton Miller <miltonm@bga.com>
Subject: Re: [PATCH] 2.6.28-git4 - powerpc - drivers build fails with !CONFIG_VIOPATH
Date: Mon, 5 Jan 2009 07:33:32 -0600
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
X-Mailer: Apple Mail (2.624)
X-Originating-IP: 205.232.218.24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 4, 2009, at 12:24 PM, Kamalesh Babulal wrote:

> Hi Milton,
>
> 	Thanks for the review comments, I am resending the patch with the
> changes you have recommended.
>
> Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

Better, but you didn't include the change log, nor did you respond to 
Stephen's reply suggesting that all users be converted to select 
viopath (versus the proposed 2 select and 5 get it via depends and 
default y).

milton

