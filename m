Return-Path: <linux-kernel-owner+w=401wt.eu-S1759364AbZDFXDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759364AbZDFXDn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 19:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755052AbZDFXDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 19:03:34 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:57449 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbZDFXDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 19:03:33 -0400
Date: Tue, 7 Apr 2009 00:03:32 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "\"\"John W. Linville\"\"" <linville@tuxdriver.com>
Subject: Re: [Bug #12870] 2.6.29-rc "TKIP: replay detected" regression
In-Reply-To: <AsKNxFx2juN.A.cV.bGn2JB@chimera>
Message-ID: <Pine.LNX.4.64.0904070001400.4254@blonde.anvils>
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera> <AsKNxFx2juN.A.cV.bGn2JB@chimera>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Apr 2009, Rafael J. Wysocki wrote:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12870
> Subject		: 2.6.29-rc "TKIP: replay detected" regression
> Submitter	: Hugh Dickins <hugh@veritas.com>
> Date		: 2009-03-11 12:07 (27 days old)
> References	: http://marc.info/?l=linux-kernel&m=123677337219148&w=4
> Handled-By	: "John W. Linville" <linville@tuxdriver.com>
> Patch		: http://marc.info/?l=linux-wireless&m=123678463704691&w=2

John's fix went into 2.6.29 final: please remove this regression now.

Hugh
