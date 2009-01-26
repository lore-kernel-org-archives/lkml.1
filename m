Return-Path: <linux-kernel-owner+w=401wt.eu-S1752127AbZAZLfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbZAZLfg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 06:35:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbZAZLf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 06:35:27 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:36088 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbZAZLf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 06:35:27 -0500
To: rjw@sisk.pl
CC: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       miklos@szeredi.hu
In-reply-to: <cX2gZ6Cy9nC.A.mqD.ZKRdJB@chimera> (rjw@sisk.pl)
Subject: Re: [Bug #12208] uml is very slow on 2.6.28 host
References: <KTnguC9mFUC.A.VNB.TJRdJB@chimera> <cX2gZ6Cy9nC.A.mqD.ZKRdJB@chimera>
Message-Id: <E1LRPkS-000132-2y@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 26 Jan 2009 12:35:24 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jan 2009, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.27 and 2.6.28.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> be listed and let me know (either way).

Yes, still unfixed.  There was some private discussion with the
scheduler guys and now I suspect this is not a scheduler regression
but a more longstanding UML bug that was made visible by some
scheduler changes.

Thanks,
Miklos

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12208
> Subject		: uml is very slow on 2.6.28 host
> Submitter	: Miklos Szeredi <miklos@szeredi.hu>
> Date		: 2008-12-12 9:35 (39 days old)
> References	: http://marc.info/?l=linux-kernel&m=122907463518593&w=4
> 
> 
> 
