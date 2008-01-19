Return-Path: <linux-kernel-owner+w=401wt.eu-S1758810AbYASWjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758810AbYASWjf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 17:39:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbYASWj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 17:39:27 -0500
Received: from eagle.jhcloos.com ([207.210.242.212]:3173 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbYASWj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 17:39:26 -0500
From: James Cloos <cloos@jhcloos.com>
To: "Francis Moreau" <francis.moro@gmail.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: Why not creating a GIT RT tree ?
In-Reply-To: <38b2ab8a0801191217m6d4a44edw28dfc6f60b5bf9f8@mail.gmail.com>
	(Francis Moreau's message of "Sat, 19 Jan 2008 21:17:15 +0100")
References: <38b2ab8a0801180544j2022af8bl252a118a295b1f34@mail.gmail.com>
	<m3zlv2kd6t.fsf@lugabout.jhcloos.org>
	<38b2ab8a0801191217m6d4a44edw28dfc6f60b5bf9f8@mail.gmail.com>
User-Agent: Gnus/5.110007 (No Gnus v0.7) Emacs/23.0.60 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAI1J
 REFUOE+lU9ESgCAIg64P1y+ngUdxhl5H8wFbbM0OmUiEhKkCYaZThXCo6KE5sCbA1DDX3genvO4d
 eBQgEMaM5qy6uWk4SfBYfdu9jvBN9nSVDOKRtwb+I3epboOsOX5pZbJNsBJFvmQQ05YMfieIBnYX
 FK2N6dOawd97r/e8RjkTLzmMsiVgrAoEugtviCM3v2WzjgAAAABJRU5ErkJggg==
Copyright: Copyright 2007 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
X-Hashcash: 1:23:080119:francis.moro@gmail.com::wfQ1Iz//H9rIv7dO:000000000000000000000000000000000000000BDqE
X-Hashcash: 1:23:080119:linux-kernel@vger.kernel.org::HFIgHny/XMRCMyZ/:000000000000000000000000000000000NPfk
X-Hashcash: 1:23:080119:rostedt@goodmis.org::w9VjZd3oewtaurh6:000000000000000000000000000000000000000001W/9t
Date: Sat, 19 Jan 2008 22:39:12 +0000
Message-ID: <m3zlv1fnjj.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Francis" == Francis Moreau <francis.moro@gmail.com> writes:

>> It is in the one-head per patch style, and has the single-file
>> patches applied rather than the quilt queue.

Francis> Why don't you have one commit per patch ?

I started it before they had the broken out patches and haven't spent
the time to put together a process for the broken out patches akin to
what I figured out for the all-in-one patches.

In other words, intertia.

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
