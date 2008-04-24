Return-Path: <linux-kernel-owner+w=401wt.eu-S1753989AbYDXUxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbYDXUxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 16:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbYDXUx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 16:53:29 -0400
Received: from eagle.jhcloos.com ([207.210.242.212]:4429 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbYDXUx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 16:53:28 -0400
From: James Cloos <cloos@jhcloos.com>
To: "Justin Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Regression: starting X locks box with git master
In-Reply-To: <dd18b0c30804241339n34f7e676xee7807c2b1cf71ff@mail.gmail.com>
	(Justin Mattock's message of "Thu, 24 Apr 2008 20:39:25 +0000")
References: <m3hcdrqb03.fsf@lugabout.jhcloos.org>
	<dd18b0c30804241339n34f7e676xee7807c2b1cf71ff@mail.gmail.com>
User-Agent: Gnus/5.110007 (No Gnus v0.7) Emacs/23.0.60 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAI1J
 REFUOE+lU9ESgCAIg64P1y+ngUdxhl5H8wFbbM0OmUiEhKkCYaZThXCo6KE5sCbA1DDX3genvO4d
 eBQgEMaM5qy6uWk4SfBYfdu9jvBN9nSVDOKRtwb+I3epboOsOX5pZbJNsBJFvmQQ05YMfieIBnYX
 FK2N6dOawd97r/e8RjkTLzmMsiVgrAoEugtviCM3v2WzjgAAAABJRU5ErkJggg==
Copyright: Copyright 2007 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
X-Hashcash: 1:23:080424:justinmattock@gmail.com::KF+SF+8QKT5cKaTk:00000000000000000000000000000000000000OjtB
X-Hashcash: 1:23:080424:linux-kernel@vger.kernel.org::ogn/TZDE815jheL+:000000000000000000000000000000000qX0e
Date: Thu, 24 Apr 2008 16:52:53 -0400
Message-ID: <m3bq3zq8jn.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Justin" == Justin Mattock <justinmattock@gmail.com> writes:

Justin> I seem to expiriencing lockups as well, vary annoying, ...
Justin> overall I think this has to do with nohz, right now I have
Justin> nohz=off with highress on and the system seems to be behaving
Justin> properly.

I hadn't thought of trying with nohz=off.

I do use nohz and (non-smp) preempt.

I'll have to give nohz=off a test before bisecting.

Thanks for the note.

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
