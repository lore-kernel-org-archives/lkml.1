Return-Path: <linux-kernel-owner+w=401wt.eu-S1765018AbXKOBVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765018AbXKOBVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 20:21:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757914AbXKOBVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 20:21:17 -0500
Received: from vms040pub.verizon.net ([206.46.252.40]:36971 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757082AbXKOBVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 20:21:16 -0500
Date: Wed, 14 Nov 2007 20:21:04 -0500
From: Russell Leighton <russ@elegant-software.com>
Subject: OT: Does Linux have any "Perfect Code"
To: LKML <linux-kernel@vger.kernel.org>
Message-id: <c9d133bdb3481fbc01a572d948049f5e@elegant-software.com>
MIME-version: 1.0 (Apple Message framework v624)
X-Mailer: Apple Mail (2.624)
Content-type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Bryan Cantrill of Sun (ala DTrace) has a notion of perfect code:

	http://blogs.sun.com/bmc/entry/on_i_dreaming_in_code

He also has some examples (from bottom comment section of above):

>
>
> Can you list a small number of examples of "software perfection"?
>
> Posted by Russell Leighton on November 14, 2007 at 04:02 AM PST #
>
> Russell,
>
> My canonical small example of perfection in Solaris would be Jeff  
> Bonwick's mod-by-a-billion code in hrt2ts():
>
> http://cvs.opensolaris.org/source/xref/onnv/onnv-gate/usr/src/uts/ 
> common/os/timers.c#875
>
> Solaris of course has lots of bigger, more complicated examples. Now  
> on the one hand, one wants to refrain from pointing to thousands of  
> lines of code and saying that there are no bugs therein, but on the  
> other, there are many subsystems that have been in place and in heavy  
> use for years without defect or modification. At the risk of being  
> egocentric, the cyclic subsystem (which is executed at least 100 times  
> per second on every Solaris system) had its last substantial fix over  
> six years ago, and its last fix of any flavor over three years ago:
>
> http://cvs.opensolaris.org/source/xref/onnv/onnv-gate/usr/src/uts/ 
> common/os/cyclic.c
>
> Modesty (and the lack, of course, of a proof of its correctness)  
> prevents me from calling the cyclic subsystem perfect -- but such as  
> unknown defects remain, there are damn few of them, and we can say  
> that they must be a result of highly usual (or at least, heretofore  
> unseen) circumstances.
>
> A non-Solaris example -- and one that I've been known to use as the  
> canonical example of the persistence of software -- is Super Mario  
> Kart. This is a game that was developed (to its completion) fifteen  
> years ago for the Super Nintendo console. Source code, to the best of  
> my knowledge, is not publicly available and may indeed be lost -- but  
> the binaries persist and (if my coworkers are any indication) remain  
> in active use. Given the longevity of, say, Homer's Odyssey, there is  
> reason to believe that Super Mario Kart will survive in perpetuity --  
> that thousands of years from now, twenty-somethings somewhere will be  
> using the software exactly as it is used today. Is this perfection?  
> Perhaps not -- but it also might not be discernible from perfection...
>
> Posted by Bryan Cantrill on November 14, 2007 at 07:51 AM PST #

Does Linux have any such examples true software perfection?


