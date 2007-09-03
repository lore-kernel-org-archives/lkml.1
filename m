Return-Path: <linux-kernel-owner+w=401wt.eu-S1755578AbXICSCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbXICSCL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 14:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbXICSB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 14:01:58 -0400
Received: from keil-draco.com ([216.193.185.50]:50154 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbXICSB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 14:01:57 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: davids@webmaster.com
Subject: Re: Fwd: That whole "Linux stealing our code" thing
Date: Mon, 3 Sep 2007 14:01:47 -0400
User-Agent: KMail/1.9.6
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
References: <MDEHLPKNGKAHNMBLJOLKOEDKGJAC.davids@webmaster.com>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKOEDKGJAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709031401.47111.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 September 2007 05:48:00 David Schwartz wrote:
> > Mr. Floeter *CAN* request that his code be removed from said fork
> > - his code
> > is solely licensed (AFAICT and IIRC) under the BSD/ISC license
> > and was only
> > covered by the dual-license because it was integrated into a work that
> > carried said dual-license. (I'm not sure how well such a revocation would
> > work in reality, but it is Mr. Floeters right.)...
>
> No. Neither the BSD license nor the GPL license permit you to revoke
> rights. Mr. Floeter's code is still available under the BSD/ISC license.
> The BSD license does not require you to make derived works available under
> a BSD license. *His* code is still available under a BSD/ISC license, of
> course, but the changed code is not.

Doesn't matter if the BSD license or the GPL *PERMITS* it or not. The fact 
remains that the person making a work available under *ANY* form of copyright 
license has the right to revoke said grant of license to anyone. The GPL 
codifies certain situations in which the person would not, personally, have 
to revoke the license, but does not limit the original copyright holders 
rights (in that regard) in any way.

The BSD/ISC license has none of the automatic conditions of the GPL, but it 
also cannot remove the copyright holder(s) from exercising their rights.

(And no, I haven't spoken to a lawyer about this - I did, however, ask a 
recently graduated law-school student where I could look for case-law and the 
text of the actual laws. What I got was some background on US copyright law 
itself and an agreement that a copyright license does not - and can not - 
affect the person holding the copyright)

> Read the BSD license. It does not require changes to be made available
> under a compatible license. This is the main difference between the BSD and
> GPL licenses.

Have done so. And that is the only part of the license that I actually don't 
like.

> Note that it would be an error to remove the BSD license text, as the BSD
> license requires you to keep it and you still need the BSD license to grant
> you distribution rights to the original work. However, the license does not
> apply to protectable aspects of the code not placed under the BSD license
> by their original author, and it is important to add a note to that effect.

Agreed, and I've never claimed otherwise. (Nor has anyone else. I believe the 
closest that anyone has come was Alan Cox saying (and I'm going to paraphrase 
it because I don't think he ever stated it well) "If you've made changes to a 
file that carries a dual BSD/GPL license and your changes are GPL only, the 
file can no longer be distributed under the BSD license at all. So it is safe 
to remove the headers from that individual file."

There is no way that a license on a constituent file can alter or affect the 
license on the whole project (if it is different). It can "muddy the waters", 
but that is about as far as I can see it going.

(I realize I may have said different, originally, but you'll have to forgive 
me. I was not in the best of moods (or the best state of mind) to be making a 
completely rational argument when I did such.)

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
