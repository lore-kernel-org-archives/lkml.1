Return-Path: <linux-kernel-owner+w=401wt.eu-S1757483AbXIRMXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483AbXIRMXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 08:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755933AbXIRMXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 08:23:40 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:32289 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973AbXIRMXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 08:23:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Sk+6txck40Pw4//Lvzo8PNz/lL/a7Xq47Mr6LkRKrYYsKgobGO7RMgYBEzlVzqdR+jHwYFty4dzN77XXG91Lcim6lS1EG8pQfrkL9qUi/NcUuTaq005PqNBQMRYxNaAJINZvyr8TBpuwI2WXEsc+/a2tb6wH6/uEpkMKcnlg88Y=
Message-ID: <a44ae5cd0709180523p646024b1u43269816e5328c9f@mail.gmail.com>
Date: Tue, 18 Sep 2007 08:23:38 -0400
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: What can be done to reduce the huge number of build fixes required to release an MM tree?
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew and all,

What can be done to reduce the huge number of build fixes required to
release an MM tree?

Perhaps it would be helpful if you identified specific individuals who
send you patches that break the build.  If necessary, we could keep a
running total.  The main thought is that maybe we need to identify who
regularly sends troublesome patches.  There are three metrics that
might be good to know:  1) Who sends patches that are regularly
broken, but sends patches rarely?  2) Who sends patches all the time,
and once in while causes trouble?  And 3) Who is causing the most
cumulative trouble?

Is there any possibility that we ought to refuse patches from people
who break the build too often?

Another area that might be helpful might be how the patches break
things.  Are there major groupings of errors that developers could be
educated about?


I am sorry you are having to work so hard to do your job, Andrew.

                Miles
