Return-Path: <linux-kernel-owner+w=401wt.eu-S933796AbXBZIaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933796AbXBZIaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 03:30:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933798AbXBZIaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 03:30:20 -0500
Received: from wr-out-0506.google.com ([64.233.184.238]:61876 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933796AbXBZIaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 03:30:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iNMcMfjnZ4A4vvZ+g0GTDGSq26rrDLonPX/cQ0dtD8HKIZaoS1dz5MH9/irHzw7ECE+tL7cOPlyWd3pHnlqrec/PCCOzL30lnQ4QYmGU+IKlgAWIrJDahdJ9/EY/wRuALMM6QVR0pr6+KkJ8Yz2tCmIdhnTJ01goaBmpOhosOFg=
Message-ID: <8d158e1f0702260030l2f3d9f2ar5c662c807f64f7f7@mail.gmail.com>
Date: Mon, 26 Feb 2007 09:30:17 +0100
From: "Patrick Ale" <patrick.ale@gmail.com>
To: "Michael-Luke Jones" <jonesml@fastmail.to>
Subject: Re: [QUESTION] Sata RAID
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <8d158e1f0702240919v33182ca2qc0a15fdd27a3f96a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8d158e1f0702240210x71f981a6xf2fe8917dac5e91a@mail.gmail.com>
	 <200702241624.17024.bzolnier@gmail.com>
	 <6C96CE3D-85F5-479D-BD44-F5DA0AE744FF@fastmail.to>
	 <8d158e1f0702240919v33182ca2qc0a15fdd27a3f96a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/24/07, Patrick Ale <patrick.ale@gmail.com> wrote:
> On 2/24/07, Michael-Luke Jones <jonesml@fastmail.to> wrote:

One more question regarding this, I am aware its not *really* kernel
related but answering this question now will save yourself a lot of
bogus emails from me about MD oopses later and all, and I want to
setup my disks right once and for all and never witness what I
witnessed last weeks with my ATA disks.

Would you use MD at all, taking in account the disks come from the
same batch and all? I hear these things about MD/RAID being pointless
when you use disks from the same brand/type/batch since they most
likely will break shortly after eachother.

Oh, and one more thing

              \|/ ____ \|/
              "@'/ ,. \`@"
              /_| \__/ |_\
                 \__U_/
<--- whoeveer programmed that into the sparc-linux oops is GOD, you're
my true hero, lol.


Patrick
