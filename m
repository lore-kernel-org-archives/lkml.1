Return-Path: <linux-kernel-owner+w=401wt.eu-S1751181AbZL0VGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751181AbZL0VGX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 16:06:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751004AbZL0VGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 16:06:22 -0500
Received: from n23b.bullet.mail.mud.yahoo.com ([68.142.206.142]:23980 "HELO
	n23b.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750823AbZL0VGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 16:06:21 -0500
X-Yahoo-Newman-Id: 979686.86221.bm@omp402.mail.mud.yahoo.com
X-Yahoo-SMTP: LRnWvK2swBBLo9OY5H0NQVPHD_u4VLt1qS0Z
X-YMail-OSG: lYdP8E8VM1nqxqTN.FmB9GHgKpzXLa2ATjxosiFMcJQraO8NB5BZG7GEeSBrvESeanK4PHUKZ3T7.TAuPCy5d3iSJsUmhD78KPGvOHE3qB9AYCYeaI67NBbDzCjpIkdH9YL7nZZxOFHiGUGIYNc_9lsUTk8ERdmdS9LtyvolkFchzs9JvXv47QVpODyBtO66GQQxLCM55RaGzUUH0DbS8LW_fNVJj2kNb3SVAOQkJVARuD1hh2cthgmvwtB_U6t70v9CoadcxbquAUZ15vezCBhixWKoS3svZP8I
X-Yahoo-Newman-Property: ymail-3
From: Craig Dunwoody <cdunwoody@graphstream.com>
To: linux-kernel@vger.kernel.org
CC: cdunwoody@graphstream.com
Re: [GIT PULL] Ceph distributed file system client for 2.6.33 
X-Mailer: MH-E 8.0.2; nmh 1.1; GNU Emacs 21.4.1
Date: Sun, 27 Dec 2009 13:06:19 -0800
Message-ID: <24388.1261947979@n20.hq.graphstream.com>
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

