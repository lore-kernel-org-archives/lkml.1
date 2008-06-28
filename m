Return-Path: <linux-kernel-owner+w=401wt.eu-S1759355AbYF1WgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759355AbYF1WgV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 18:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753886AbYF1WgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 18:36:13 -0400
Received: from eagle.jhcloos.com ([207.210.242.212]:3698 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389AbYF1WgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 18:36:12 -0400
X-Greylist: delayed 656 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Jun 2008 18:36:12 EDT
From: James Cloos <cloos@jhcloos.com>
To: linux-kernel@vger.kernel.org
Cc: Joe Peterson <joe@skyrush.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] UTC timestamp option for FAT filesystems
In-Reply-To: <4863CC89.9070705@skyrush.com> (Joe Peterson's message of "Thu,
	26 Jun 2008 11:06:17 -0600")
References: <4861D685.4070308@skyrush.com> <87od5pqh4o.fsf@basil.nowhere.org>
	<4862DB28.3050001@skyrush.com> <48630286.2050006@skyrush.com>
	<87wskck5wi.fsf@devron.myhome.or.jp> <48639863.808@skyrush.com>
	<877iccxnwi.fsf@devron.myhome.or.jp> <4863B9AF.4080105@skyrush.com>
	<87zlp8w4br.fsf@devron.myhome.or.jp> <4863CC89.9070705@skyrush.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.0.60 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAI1J
 REFUOE+lU9ESgCAIg64P1y+ngUdxhl5H8wFbbM0OmUiEhKkCYaZThXCo6KE5sCbA1DDX3genvO4d
 eBQgEMaM5qy6uWk4SfBYfdu9jvBN9nSVDOKRtwb+I3epboOsOX5pZbJNsBJFvmQQ05YMfieIBnYX
 FK2N6dOawd97r/e8RjkTLzmMsiVgrAoEugtviCM3v2WzjgAAAABJRU5ErkJggg==
Copyright: Copyright 2008 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
Date: Sat, 28 Jun 2008 18:24:39 -0400
Message-ID: <m31w2h6vup.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Joe" == Joe Peterson <joe@skyrush.com> writes:

Joe> For a camera, since DST is not taken into account.  If you really
Joe> want to set your camera to local time and are willing to accept the
Joe> inherent issues, why not just use local time FAT behavior as it is
Joe> now in Linux.

Taking the rôle of Devil’s Advocate, why presume that the camera and the
box will have the same idea of local time?  One might set the camera to
local time on a vacation, take some pics, return home and only them mount
the card on one's box.

Of course, that only works well if one uses different cards for each
timezone one visits.  And it may well be unusual for typical digital
camera owners to bother with setting the time.  But it can't be unknown.

It does seem likely that anyone who sets the camera's time at all will
probably prefer localtime.  And if they know that one card has photos
taken during a winter visit to Orlando, and another from a summer trip
to Alaska, they may want to copy over accurate timestamps.

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
