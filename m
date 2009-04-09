Return-Path: <linux-kernel-owner+w=401wt.eu-S935993AbZDISSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935993AbZDISSV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 14:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758669AbZDISR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 14:17:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:54263 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757569AbZDISR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 14:17:57 -0400
Message-ID: <49DE3BE3.80806@kernel.org>
Date: Thu, 09 Apr 2009 11:18:11 -0700
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Niel Lambrechts <niel.lambrechts@gmail.com>
CC: "linux.kernel" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29 regression: ATA bus errors on resume
References: <ckpL0-3TE-3@gated-at.bofh.it> <ckpL0-3TE-5@gated-at.bofh.it> <ckpL0-3TE-7@gated-at.bofh.it> <ckpL0-3TE-9@gated-at.bofh.it> <ckpL0-3TE-11@gated-at.bofh.it> <ckpL0-3TE-1@gated-at.bofh.it> <cllvN-2Gf-1@gated-at.bofh.it> <49D0D788.6070405@gmail.com> <49D419E8.2080603@kernel.org> <49D4591B.3070807@gmail.com> <49D46096.1040701@kernel.org> <49D49B8A.7070408@gmail.com> <49D4C886.1010101@gmail.com> <49D6E7FA.3000306@kernel.org> <49D98C9E.2000507@gmail.com> <49D9D4D8.2020608@kernel.org> <49DA489E.1030801@gmail.com> <49DA5A83.2070002@kernel.org> <49DA7392.4020809@gmail.com>
In-Reply-To: <49DA7392.4020809@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 09 Apr 2009 18:17:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Niel Lambrechts wrote:
> On 04/06/2009 09:39 PM, Tejun Heo wrote:
> Sorry, my bad - I assumed the 2nd patch actually made a functional
> difference... :)
> 
> Here is the output on 2.6.29.1 with your new patch - still nothing
> serious happening, resume still seems okay!

Hmm... none of the debugging messages got triggered, so there should
be no noticeable timing change.  It seems like you're being lucky for
the time being.  Can you please keep testing and report back?

Thanks.

-- 
tejun
