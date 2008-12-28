Return-Path: <linux-kernel-owner+w=401wt.eu-S1756637AbYL1WOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637AbYL1WOZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 17:14:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754417AbYL1WOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 17:14:14 -0500
Received: from vms173005pub.verizon.net ([206.46.173.5]:42956 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913AbYL1WOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 17:14:14 -0500
Date: Sun, 28 Dec 2008 14:14:12 -0800
From: John Dierks <j.dierks@Verizon.net>
Subject: kernel bug in openSUSE 11.1 64 bit
To: linux-kernel@vger.kernel.org
Message-id: <4957FA34.1050501@Verizon.net>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 2.0.0.18 (Macintosh/20081105)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings -

I am a newbie and not familiar with the accepted way of posting bugs,
so I am simply sending you a link to the appropriate forum discussion.

I believe we have a kernel bug in the released version of openSUSE 11.1 
(64 bit).

I have confirmed what another user (ansbar) found:  Any attempt to 
install 64 bit
11.1 from DVD or NET media onto a D945GCLF2 platform results in a
kernel oops soon after the version of kernel supplied with the distribution
loads and runs.

As an aside, the platform I attempted to upgrade currently is running 
11.0 (64 bit),
which has been running without any evidence of problems.

I hope the discussion gives you enough info to go on.  If not, feel free to
ask questions.  Here's the link:

    
http://forums.opensuse.org/install-boot-login/402136-kernel-panic-11-1-64bit.html

Thanks,
John Dierks
