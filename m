Return-Path: <linux-kernel-owner+w=401wt.eu-S1031290AbXD2TjC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031290AbXD2TjC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 15:39:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031294AbXD2TjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 15:39:01 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:55649 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031290AbXD2TjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 15:39:00 -0400
Date: Sun, 29 Apr 2007 21:38:43 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andrew Wang <andrewxwang@yahoo.com.tw>
cc: linux-kernel@vger.kernel.org
Subject: Re: Why ask Sun for ZFS while we have ReiserFS4 !?
In-Reply-To: <660658.6960.qm@web73512.mail.tp2.yahoo.com>
Message-ID: <Pine.LNX.4.61.0704292052050.22744@yvahk01.tjqt.qr>
References: <660658.6960.qm@web73512.mail.tp2.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.5 points, 6.0 required
	0.5 PLING_QUERY            Subject has exclamation mark and question mark
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 30 2007 02:18, Andrew Wang wrote:
>
>ZFS has some nice features, but ReiserFS4 also is a
>good file system.
>
>Why do we want Sun to release ZFS under GPL, while
>ReiserFS4 is already available under GPL!?

Do we?

>I know that ReiserFS4 breaks Linux coding standards.
>However, even if Sun releases ZFS under GPL, we still
>need to port it to the Linux kernel.
>
>I think for those who ask/beg Sun to release ZFS under
>GPL should do the work to get ReiserFS4 to Linux!

It's already there for Linux. It's just that you have to
merge it yourself.


RR:
Some people have different opinions about what constitutes
a good filesystem. One half goes with ext, the other with
<CENSORED>, mainly because "it works" for them, has "proven
to be stable enough", "<CENSORED> has not proven to be
stable", or perhaps just out of fs beliefs/conviction.
I myself would not 'want' either zfs or r4 at this time,
and there's even an objective reason behind it.



Jan
-- 
