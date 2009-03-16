Return-Path: <linux-kernel-owner+w=401wt.eu-S1762134AbZCPVyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762134AbZCPVyd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 17:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761354AbZCPVyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 17:54:13 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:52659 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761388AbZCPVyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 17:54:11 -0400
Date: Mon, 16 Mar 2009 21:53:28 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [Bug #12870] 2.6.29-rc "TKIP: replay detected" regression
In-Reply-To: <GCLaknAim2M.A.mbC.M4BvJB@chimera>
Message-ID: <Pine.LNX.4.64.0903162150060.28429@blonde.anvils>
References: <MiincthRUSI.A.eKC.F4BvJB@chimera> <GCLaknAim2M.A.mbC.M4BvJB@chimera>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Mar 2009, Rafael J. Wysocki wrote:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12870
> Subject		: 2.6.29-rc "TKIP: replay detected" regression
> Submitter	: Hugh Dickins <hugh@veritas.com>
> Date		: 2009-03-11 12:07 (4 days old)
> References	: http://marc.info/?l=linux-kernel&m=123677337219148&w=4
> Handled-By	: John W. Linville <linville@tuxdriver.com>

Yes, it should still be listed, but could go into the "with patches"
section: there's a good patch from John in linux-next, which I expect
he'll get Linus to pull in due course.

Hugh
