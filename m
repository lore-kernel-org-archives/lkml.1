Return-Path: <linux-kernel-owner+w=401wt.eu-S1762708AbYARWH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762708AbYARWH4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 17:07:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764360AbYARWHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 17:07:41 -0500
Received: from eagle.jhcloos.com ([207.210.242.212]:3168 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763543AbYARWHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 17:07:38 -0500
X-Greylist: delayed 483 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jan 2008 17:07:38 EST
From: James Cloos <cloos@jhcloos.com>
To: "Francis Moreau" <francis.moro@gmail.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: Why not creating a GIT RT tree ?
In-Reply-To: <38b2ab8a0801180544j2022af8bl252a118a295b1f34@mail.gmail.com>
	(Francis Moreau's message of "Fri, 18 Jan 2008 14:44:38 +0100")
References: <38b2ab8a0801180544j2022af8bl252a118a295b1f34@mail.gmail.com>
User-Agent: Gnus/5.110007 (No Gnus v0.7) Emacs/23.0.60 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAI1J
 REFUOE+lU9ESgCAIg64P1y+ngUdxhl5H8wFbbM0OmUiEhKkCYaZThXCo6KE5sCbA1DDX3genvO4d
 eBQgEMaM5qy6uWk4SfBYfdu9jvBN9nSVDOKRtwb+I3epboOsOX5pZbJNsBJFvmQQ05YMfieIBnYX
 FK2N6dOawd97r/e8RjkTLzmMsiVgrAoEugtviCM3v2WzjgAAAABJRU5ErkJggg==
Copyright: Copyright 2007 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
X-Hashcash: 1:23:080118:rostedt@goodmis.org::TxyX7R68pUcigj0H:0000000000000000000000000000000000000000003MOf
X-Hashcash: 1:23:080118:francis.moro@gmail.com::JuveJtfzWo4m+w+M:0000000000000000000000000000000000000003pWN
X-Hashcash: 1:23:080118:linux-kernel@vger.kernel.org::2G0oVVXnOemkeQyd:0000000000000000000000000000000004Jew
Date: Fri, 18 Jan 2008 21:59:22 +0000
Message-ID: <m3zlv2kd6t.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Francis" == Francis Moreau <francis.moro@gmail.com> writes:

Francis> I can't find a rt tree anywhere and all new rt release spoke
Francis> about a patchset to apply on mainline kernels.

It is not perfect, but I do have a git repo of the rt history-of-patches
up at:

 git://git.kernel.org/pub/scm/linux/kernel/git/cloos/rt-2.6.git
http://www.kernel.org/pub/scm/linux/kernel/git/cloos/rt-2.6.git

Gitweb URL is:

http://git.kernel.org/?p=linux/kernel/git/cloos/rt-2.6.git

It is in the one-head per patch style, and has the single-file patches
applied rather than the quilt queue.

But it will at least allow comparisons among the various versions.

The master head matches the most current patch.

(I try to keep it updated the same day as patches are announced, but
it does sometimes lag a day or two.)

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
