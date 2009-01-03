Return-Path: <linux-kernel-owner+w=401wt.eu-S932897AbZACVhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932897AbZACVhI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 16:37:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755697AbZACVg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 16:36:56 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54282 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709AbZACVgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 16:36:55 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
X-Fcc: ~/Mail/linus
Cc: Sripathi Kodi <sripathik@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Frank Mayhar <fmayhar@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] getrusage: RUSAGE_THREAD should return ru_utime and ru_stime
In-Reply-To: KOSAKI Motohiro's message of  Sunday, 4 January 2009 05:40:37 +0900 <20090104053654.069C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20090104053654.069C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Emacs: resistance is futile; you will be assimilated and byte-compiled.
Message-Id: <20090103210617.18CBAFC299@magilla.sf.frob.com>
Date: Sat,  3 Jan 2009 13:06:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think you're right.  Good catch.

Acked-by: Roland McGrath <roland@redhat.com>


Thanks,
Roland
