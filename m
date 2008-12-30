Return-Path: <linux-kernel-owner+w=401wt.eu-S1752723AbYL3NOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbYL3NOh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 08:14:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbYL3NO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 08:14:28 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:34689 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbYL3NO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 08:14:27 -0500
Message-ID: <004501c96a80$85357100$0201a8c0@bui.materna.com>
From: "Roland" <devzero@web.de>
To: <j.dierks@Verizon.net>
Cc: <linux-kernel@vger.kernel.org>, <jj@chaosbits.net>
Subject: Re: kernel bug in openSUSE 11.1 64 bit
Date: Tue, 30 Dec 2008 14:14:17 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3350
X-Provags-ID: V01U2FsdGVkX1/S1dlKQ03oEMLDO9O0hO51nq1ocPf8LUzfEGbT
	SAWw3E2XA0j1Kat8OxKZHBL0O7LU2if9iWJgpDsdAqAgbxi9gu
	P5ICIFLYQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello John,

do you see any relation to this one ?
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/279186

do you use the latest bios for that board?
if not,maybe you could try if that helps ?

regards
Roland




List:       linux-kernel
Subject:    kernel bug in openSUSE 11.1 64 bit
From:       John Dierks <j.dierks () Verizon ! net>
Date:       2008-12-28 22:14:12
Message-ID: 4957FA34.1050501 () Verizon ! net
[Download message RAW]

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
--



