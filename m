Return-Path: <linux-kernel-owner+w=401wt.eu-S1756025AbZEYBxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbZEYBxm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 21:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754359AbZEYBxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 21:53:32 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:6891 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756AbZEYBxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 21:53:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pYD/+RdELnE9XAfZ06NxOS4Cumpdouzeocfxwli5RXgKRHJHaOiTwWPpyR+/5U0kkI
         DtqYI4Y+Elg+0ciuSa0GVzvIR3tmfToRjzuquv7Ot3iaHJ9Z9Q1KpcB9BcV9uXVzN0Rv
         xKKMmTStIKIpAkYDaCfgA0ZlMxoKyFjnazFU0=
MIME-Version: 1.0
In-Reply-To: <20090525011819.GA9805@sli10-desk.sh.intel.com>
References: <3d2f29dc0905180125x5e7ef51dqf10955a3d44336e2@mail.gmail.com>
	 <200905242236.22715.rjw@sisk.pl> <4A19BA09.4050502@zytor.com>
	 <20090525011819.GA9805@sli10-desk.sh.intel.com>
Date: Sun, 24 May 2009 21:53:32 -0400
Message-ID: <3d2f29dc0905241853h594aa2a9ta21dee45979c567e@mail.gmail.com>
Subject: Re: Boot problems with 2.6.29.1 - cannot smoothly boot on battery
From: Chris Howie <cdhowie@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 24, 2009 at 9:18 PM, Shaohua Li <shaohua.li@intel.com> wrote:
> if this is a AMD CPU, please check http://bugzilla.kernel.org/show_bug.cgi?id=13233

Ahh, that sounds like it.  I first noticed the problem in 2.6.28 after
switching from 2.6.26 (but never tried 2.6.27).  So the information
about versions is indeed consistent.  I'm on an amd64 cpu.

Thanks everyone for the suggestions, I will try to take a look within
the next couple of days and report my findings.

-- 
Chris Howie
http://www.chrishowie.com
http://en.wikipedia.org/wiki/User:Crazycomputers
