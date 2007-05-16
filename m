Return-Path: <linux-kernel-owner+w=401wt.eu-S1762057AbXEPUQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762057AbXEPUQF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 16:16:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758640AbXEPUP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 16:15:56 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:37969 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757846AbXEPUPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 16:15:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cK5l9hhx1M8C6aBRDb82vC2nDs/wq5VrYIgWHfQ8AXDiC5vHg9llDGogVIkQU0TtrKOWfN/HCzoizwVkGOuZW2ABpdWa9yef1ISGJOapnCQEDWD/E6/Qh/JZk1oqKsekn9T7in118P/yfcIrL7XmG2uBeU66WWSTx5l9QO23Ncs=
Message-ID: <9a8748490705161315p44830796t22f7f31f784e0852@mail.gmail.com>
Date: Wed, 16 May 2007 22:15:53 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Bhutani Meeta-W19091" <Meeta.Bhutani@motorola.com>
Subject: Re: Contributor Agreement/Copyright Assignment
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <7376BC9FD0C11A4CA373508199DEED1802E35A76@de01exm65.ds.mot.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7376BC9FD0C11A4CA373508199DEED1802E35A76@de01exm65.ds.mot.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/05/07, Bhutani Meeta-W19091 <Meeta.Bhutani@motorola.com> wrote:
>
> Motorola would like to understand if kernel.org has a contributor
> agreement (or a copyright assignment agreement) that is posted somewhere
> ?
As far as I know, no.

> We are investigating what would be needed from a legal standpoint to
> possibly contribute in the future.
>
I am not a lawyer, but my personal understanding is this:

1. Any code you contribute has to be licensed under the GNU GPL v2
(preferably) or a different, but 100% compatible, license (usually
acceptable).
For the text of the GNU GPL v2, please see the file "COPYING" in the
root of the kernel source tree.
For a list of other Open Source licenses, see
http://www.opensource.org/licenses/category (note: GPLv2 is strongly
prefered)

2. When submitting your code, please include Signed-off-by: lines as
pr Section 11 in Documentation/SubmittingPatches

3. Make sure your patches adhere to the guidelines laid out in
Documentation/CodingStyle (unless a specific maintainer tells you
otherwise)


A good place to start when looking for info is  Documentation/HOWTO.

A few quotes from Documentation/HOWTO that seem relevant (please do
read the document in full yourself for the full story - this is a good
starting point) can be found below;

"
...
It contains instructions on how to become a Linux kernel developer and
how to learn
to work with the Linux kernel development community.
...
Legal Issues
------------

The Linux kernel source code is released under the GPL.  Please see the
file, COPYING, in the main directory of the source tree, for details on
the license.  If you have further questions about the license, please
contact a lawyer, and do not ask on the Linux kernel mailing list.  The
people on the mailing lists are not lawyers, and you should not rely on
their statements on legal matters.
...
"

Various other documents that are worth reading in the kernel source :

README
Documentation/SubmitChecklist
Documentation/SubmittingDrivers
Documentation/SubmittingPatches
Documentation/Changes

There are many more documents in the Documentation/ directory that are
worth reading as well...


Looking forward to your contributions.


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
