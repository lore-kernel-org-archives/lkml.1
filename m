Return-Path: <linux-kernel-owner+w=401wt.eu-S1755951AbZCUTw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbZCUTw6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 15:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758105AbZCUTvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 15:51:51 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:55003 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758065AbZCUTvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 15:51:49 -0400
Date: Sat, 21 Mar 2009 19:51:04 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [Bug #12870] 2.6.29-rc "TKIP: replay detected" regression
In-Reply-To: <l8NZ2a3iQtG.A.KM.jZTxJB@chimera>
Message-ID: <Pine.LNX.4.64.0903211948190.9385@blonde.anvils>
References: <GPBuLTara4J.A.3kH.TZTxJB@chimera> <l8NZ2a3iQtG.A.KM.jZTxJB@chimera>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Mar 2009, Rafael J. Wysocki wrote:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12870
> Subject		: 2.6.29-rc "TKIP: replay detected" regression
> Submitter	: Hugh Dickins <hugh@veritas.com>
> Date		: 2009-03-11 12:07 (11 days old)
> References	: http://marc.info/?l=linux-kernel&m=123677337219148&w=4
> Handled-By	: John W. Linville <linville@tuxdriver.com>
> Patch		: http://marc.info/?l=linux-wireless&m=123678463704691&w=2

Yes, it still needs to be listed: I don't know why,
but John's patch has not yet appeared in Linus's tree.

Hugh
