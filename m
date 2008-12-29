Return-Path: <linux-kernel-owner+w=401wt.eu-S1753670AbYL2HDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670AbYL2HDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 02:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbYL2HDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 02:03:12 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:9381 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbYL2HDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 02:03:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:sender:to:subject:cc:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :x-google-sender-auth;
        b=ohPr7YwR60ZS+PD2HMajRQlQWBvurLWvCFiD6dUuN/TN0JYnr0/mLjNCVLD762STYz
         n8um1L2j/+/esewCQGc1XZHtWJxr/NktxnaeEwAEqeOT6jz7ashIBOLeaHTlx9ok63sZ
         HsnbhykIUat8eqzwG1hM0uek3uF1de31pxhm0=
Message-ID: <43d009740812282303r2015e6beyc2dae4c26d6aa686@mail.gmail.com>
Date: Mon, 29 Dec 2008 14:03:09 +0700
From: "Igor Podlesny" <for.poige+linux@gmail.com>
Reply-To: for.poige+linux@gmail.com
To: "Willy Tarreau" <w@1wt.eu>
Subject: > I even didn't have a backtrace.
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 9bd0d22eb05746d9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/29 Igor Podlesny <for.poige+linux@gmail.com>:
> 2008/12/29 Willy Tarreau <w@1wt.eu>:
>> On Mon, Dec 29, 2008 at 12:39:55PM +0700, Igor Podlesny wrote:
> [...]
>> Well, I won't say that I find them 100% rock solid, but you seem to be
>> able to reproduce a lot of serious issues. Have you filed bug reports
>> to get them fixed ? You cannot expect people to fix bugs they're not
>> aware of !
>
>        I even didn't have a backtrace. What's to fill in? "It just crashed 2
> times, Dear Bugzilla"? :-)
>
	BTW, I wonder -- can the kernel store crash related information (if
any) in RAM, at certain addresses, so it can survive warm reboot and
get displayed "in dmesg" on the next boot?

-- 
End of message. Next message?
