Return-Path: <linux-kernel-owner+w=401wt.eu-S1756119AbYE1V6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbYE1V6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 17:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754469AbYE1V6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 17:58:32 -0400
Received: from vms044pub.verizon.net ([206.46.252.44]:54508 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770AbYE1V6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 17:58:32 -0400
Date: Wed, 28 May 2008 17:58:28 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: floppy question of the hour
In-reply-to: <20080528195947.GQ16162@csclub.uwaterloo.ca>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Phillip Susi <psusi@cfl.rr.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Message-id: <200805281758.29018.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200805232114.20937.gene.heskett@gmail.com>
 <483DB49D.7040706@cfl.rr.com> <20080528195947.GQ16162@csclub.uwaterloo.ca>
User-Agent: KMail/1.9.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 May 2008, Lennart Sorensen wrote:
>On Wed, May 28, 2008 at 03:38:05PM -0400, Phillip Susi wrote:
>> Lennart Sorensen wrote:
>> >Just do what the Amiga did:  Read the entire track into a buffer in
>> >memory, then deal with the sectors, and write the entire track back. :)
>>
>> IIRC, there is no way to detect the interleave factor that the media has
>> been formatted with, unless you maybe try several and see which one
>> reads fastest.
>
>Yeah, the Amiga trick wouldn't work.  The Amiga had no interleave.  It
>didn't even have sector gaps.  Just 11 consequtive sectors worth of data
>per track and one gap at the end of the track.  I really doubt any other
>system could emulate that floppy access method without extra hardware.

The drives, at least for the 880k format, were std chinon 3.5" drives.  However, 
I was under the impression there was about a 20 byte gap with the sector number 
and a short A5 A5 synch string between the sectors.  I still have a big box 
A-2k, with one DD drive, and one of the special 1760k 150 rpm HD drives too.

But its been nearly a decade since an HD failure prompted me to store it in the 
basement and learn to really use the first linux box I ever built in 1998, 
RH-5.1 on it.  So my memory could be hazy, after all its 73 years old & 
counting. :)

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
My philosophy is: Don't think.
		-- Charles Manson
