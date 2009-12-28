Return-Path: <linux-kernel-owner+w=401wt.eu-S1751218AbZL1ARx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751218AbZL1ARx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 19:17:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751048AbZL1ARw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 19:17:52 -0500
Received: from n14.bullet.mail.mud.yahoo.com ([68.142.206.41]:31666 "HELO
	n14.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750947AbZL1ARv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 19:17:51 -0500
X-Yahoo-Newman-Id: 426800.53641.bm@omp424.mail.mud.yahoo.com
X-Yahoo-SMTP: LRnWvK2swBBLo9OY5H0NQVPHD_u4VLt1qS0Z
X-YMail-OSG: 6QOZ7PYVM1kyHrM.fgtHga5f3gysQhHFNdkh.35kJ42epZOBWbJnMl7Ic9W6NDZ_1AWSxfMNLmmX5wgtCUYWF9.FB9zv1rl_pcN4sc3gbvkYR9mLEWtB89dAXMjFuehFCeblquwNzSHE2euvdNKQLy1ibR9iueUZ3MaCDzYtrfJGmUiwHPbUPu043.we6ClPJlX3FzUKtUeTJU2lKAJCtYRqoWeZWzmzz7lT.8ixITHIOBuoxD6kF4dktz6ba0Dodj9Z1G9ea3K7bcwjN_2Tbxm6zFeNkGZtbA--
X-Yahoo-Newman-Property: ymail-3
From: Craig Dunwoody <cdunwoody@graphstream.com>
To: linux-kernel@vger.kernel.org
CC: cdunwoody@graphstream.com
Subject: Re: [GIT PULL] Ceph distributed file system client for 2.6.33 
X-Mailer: MH-E 8.0.2; nmh 1.1; GNU Emacs 21.4.1
Date: Sun, 27 Dec 2009 16:17:50 -0800
Message-ID: <27445.1261959470@n20.hq.graphstream.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sage weil writes (2009/12/21):
>If you want stability, then it's probably too early to merge.  If you
>want active users, that essentially hinges on stability too.  But if
>it's interest in/demand for an alternative distributed fs, then the
>sooner it's merged the better.

I understand there are many considerations about when to merge something
new, but in general would like to see the Ceph client merged sometime
soon.

In my view, there is a wide range of applications for which Ceph has
the potential to be significantly more efficient than the other
distributed file systems that I know about.

Ceph has a solid architecture and a small but strong dev team.  I
believe that the project is now at a point where wider-scale testing
can greatly accelerate progress toward production-level usability.
Having the client in mainline will help reduce barriers to such
testing.

Craig Dunwoody
GraphStream Incorporated

