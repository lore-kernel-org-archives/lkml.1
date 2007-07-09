Return-Path: <linux-kernel-owner+w=401wt.eu-S1755850AbXGIJgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbXGIJgr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 05:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbXGIJgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 05:36:40 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:41931 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbXGIJgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 05:36:40 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: malicious filesystems (was Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway)
Date: Mon, 9 Jul 2007 11:36:32 +0200
User-Agent: KMail/1.9.7
Cc: rjw@sisk.pl, pavel@ucw.cz, paulus@samba.org, stern@rowland.harvard.edu,
       johannes@sipsolutions.net, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org,
       benh@kernel.crashing.org, nigel@nigel.suspend2.net
References: <200707050858.03638.oliver@neukum.org> <200707082307.15616.rjw@sisk.pl> <E1I7pXr-0001Qn-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1I7pXr-0001Qn-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707091136.33581.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 9. Juli 2007 schrieb Miklos Szeredi:
> In that case the "we need suspend to be invisible to userspace" as a
> reason to use the freezer would also be moot, since if you don't
> schedule userspace after offlining the CPUs, it can't notice this.

After? Can you do the offlining atomically?

	Regards
		Oliver

