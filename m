Return-Path: <linux-kernel-owner+w=401wt.eu-S1752964AbZJTXcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbZJTXcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 19:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbZJTXcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 19:32:22 -0400
Received: from eagle.jhcloos.com ([207.210.242.212]:4566 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbZJTXcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 19:32:21 -0400
From: James Cloos <cloos@jhcloos.com>
To: john stultz <johnstul@us.ibm.com>
Cc: davehart_gmail_exchange_tee@davehart.net, hackers@lists.ntp.org,
       linux-kernel@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [ntp:hackers] ntp-dev-4.2.5p235-RC build failure: MOD_NANO not  #defined
In-Reply-To: <1f1b08da0910201345w61f1bb4yb99b5f052ea77ac4@mail.gmail.com>
	(john stultz's message of "Tue, 20 Oct 2009 13:45:53 -0700")
References: <m3iqe9kj18.fsf@lugabout.jhcloos.org>
	<85d954180910201227q528ff210v575df8c1f83e9ada@mail.gmail.com>
	<1f1b08da0910201345w61f1bb4yb99b5f052ea77ac4@mail.gmail.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1.50 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAI1J
 REFUOE+lU9ESgCAIg64P1y+ngUdxhl5H8wFbbM0OmUiEhKkCYaZThXCo6KE5sCbA1DDX3genvO4d
 eBQgEMaM5qy6uWk4SfBYfdu9jvBN9nSVDOKRtwb+I3epboOsOX5pZbJNsBJFvmQQ05YMfieIBnYX
 FK2N6dOawd97r/e8RjkTLzmMsiVgrAoEugtviCM3v2WzjgAAAABJRU5ErkJggg==
Copyright: Copyright 2009 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
Date: Tue, 20 Oct 2009 19:22:00 -0400
Message-ID: <m3aazlk5vz.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Hashcash: 1:30:091020:johnstul@us.ibm.com::ySwuUyvz85BwSESQ:00000000000000000000000000000000000000000U/tO4
X-Hashcash: 1:30:091020:davehart_gmail_exchange_tee@davehart.net::Lcd9zuSVtKY/REzh:00000000000000000000vx03C
X-Hashcash: 1:30:091020:hackers@lists.ntp.org::dIWxVq9l37yX9PKQ:000000000000000000000000000000000000000UEAF2
X-Hashcash: 1:30:091020:linux-kernel@vger.kernel.org::q5Vc+QQUbP8s2MMF:00000000000000000000000000000000LhbVQ
X-Hashcash: 1:30:091020:zippel@linux-m68k.org::4cgNejk6apW2pJtk:000000000000000000000000000000000000000BTuEZ
X-Hashcash: 1:30:091020:tglx@linutronix.de::Mtg8KWORa8AYbCV9:000000000000000000000000000000000000000000O9IlN
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "john" == john stultz <johnstul@us.ibm.com> writes:

john> The kernel has already been fixed, but glibc still needs to pick up the change.
john> See the kernel commit here:
john> http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=commitdiff;h=c95b4502ad7fe8f3b9954aec794b00ac0046ab3a

Ah.  I only looked in my (up to date) clone of Linus’ tree; I didn’t
check the trees-to-pull.

Will that be part of a pull request for the current rc or only for the
next merge window?

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
