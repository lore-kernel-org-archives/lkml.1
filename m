Return-Path: <linux-kernel-owner+w=401wt.eu-S1754477AbZALKE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477AbZALKE4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 05:04:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbZALKEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 05:04:47 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34724 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbZALKEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 05:04:46 -0500
To: rjw@sisk.pl
CC: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       miklos@szeredi.hu
In-reply-to: <nHCfeC0YLrE.A.kFD.NbfaJB@chimera> (rjw@sisk.pl)
Subject: Re: [Bug #12208] uml is very slow on 2.6.28 host
References: <nn3SOLVZ28H.A.bY.CafaJB@chimera> <nHCfeC0YLrE.A.kFD.NbfaJB@chimera>
Message-Id: <E1LMJex-0001lB-SE@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 12 Jan 2009 11:04:39 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Jan 2009, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.27 and 2.6.28.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12208
> Subject		: uml is very slow on 2.6.28 host
> Submitter	: Miklos Szeredi <miklos@szeredi.hu>
> Date		: 2008-12-12 9:35 (31 days old)
> References	: http://marc.info/?l=linux-kernel&m=122907463518593&w=4

Yes, this still exists on latest -git.

Thanks,
Miklos
