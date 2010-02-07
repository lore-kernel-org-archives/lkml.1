Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab0BGUEY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 15:04:24 -0500
Received: from eagle.jhcloos.com ([207.210.242.212]:39645 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab0BGUEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 15:04:22 -0500
X-Greylist: delayed 485 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Feb 2010 15:04:22 EST
From: James Cloos <cloos@jhcloos.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.33-rc7
In-Reply-To: <4B6E4793.3010201@teksavvy.com> (Mark Lord's message of "Sat, 06
	Feb 2010 23:54:43 -0500")
References: <alpine.LFD.2.00.1002061422430.3829@localhost.localdomain>
	<alpine.LFD.2.00.1002061445210.3829@localhost.localdomain>
	<4B6E4793.3010201@teksavvy.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1.90 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAI1J
 REFUOE+lU9ESgCAIg64P1y+ngUdxhl5H8wFbbM0OmUiEhKkCYaZThXCo6KE5sCbA1DDX3genvO4d
 eBQgEMaM5qy6uWk4SfBYfdu9jvBN9nSVDOKRtwb+I3epboOsOX5pZbJNsBJFvmQQ05YMfieIBnYX
 FK2N6dOawd97r/e8RjkTLzmMsiVgrAoEugtviCM3v2WzjgAAAABJRU5ErkJggg==
Copyright: Copyright 2009 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
Date: Sun, 07 Feb 2010 14:10:31 -0500
Message-ID: <m3k4uo275s.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Hashcash: 1:30:100207:kernel@teksavvy.com::eJXzEa5GZFvSCXrz:0000000000000000000000000000000000000000086wXD
X-Hashcash: 1:30:100207:linux-kernel@vger.kernel.org::fRmMfZ6i524qNc+e:00000000000000000000000000000000NbKqs
X-Hashcash: 1:30:100207:torvalds@linux-foundation.org::5U3wLcbhZSIjrMoU:0000000000000000000000000000000pog4P
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Mark" == Mark Lord <kernel@teksavvy.com> writes:

Mark> I just wish the GNU tar folk had the sense to combine -z and -j
Mark> into a single flag.

Try the -a flag:

 -a, --auto-compress   use archive suffix to determine the compression program

(Which does seem to be on by default, now, as mentioned in the other reply.)

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
