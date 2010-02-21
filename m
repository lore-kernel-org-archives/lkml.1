Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab0BUCMv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 21:12:51 -0500
Received: from eagle.jhcloos.com ([207.210.242.212]:43290 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755719Ab0BUCMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 21:12:49 -0500
From: James Cloos <cloos@jhcloos.com>
To: Dave Airlie <airlied@gmail.com>
Cc: linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
       linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
       linux-btrfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net
Subject: Re: [Regression] Filesystem I/O is CPU-bound in rc7 and rc8
In-Reply-To: <21d7e9971002191403tdc16bf9h5ebf6b48fec95d6a@mail.gmail.com>
	(Dave Airlie's message of "Sat, 20 Feb 2010 08:03:57 +1000")
References: <m3pr48bjfg.fsf@lugabout.jhcloos.org>
	<20100215154516.GB11057@think> <m3d403632g.fsf@lugabout.jhcloos.org>
	<21d7e9971002191302s76111f6fyd986c51b66e214ae@mail.gmail.com>
	<m3wry8nbyl.fsf@lugabout.jhcloos.org>
	<21d7e9971002191403tdc16bf9h5ebf6b48fec95d6a@mail.gmail.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1.90 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAI1J
 REFUOE+lU9ESgCAIg64P1y+ngUdxhl5H8wFbbM0OmUiEhKkCYaZThXCo6KE5sCbA1DDX3genvO4d
 eBQgEMaM5qy6uWk4SfBYfdu9jvBN9nSVDOKRtwb+I3epboOsOX5pZbJNsBJFvmQQ05YMfieIBnYX
 FK2N6dOawd97r/e8RjkTLzmMsiVgrAoEugtviCM3v2WzjgAAAABJRU5ErkJggg==
Copyright: Copyright 2009 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
Date: Sat, 20 Feb 2010 21:12:08 -0500
Message-ID: <m31vgfbalr.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Dave" == Dave Airlie <airlied@gmail.com> writes:

Dave> I've just sent a pull req to Linus
Dave> http://bugzilla.kernel.org/show_bug.cgi?id=15328
Dave> this
Dave> http://bugzilla.kernel.org/attachment.cgi?id=25107
Dave> patch.

That patch does indeed fix the regression here.

Thanks!

It looks like my report is a dup of bug 15328.

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
