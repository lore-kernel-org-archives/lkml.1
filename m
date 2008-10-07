Return-Path: <linux-kernel-owner+w=401wt.eu-S1757509AbYJGUg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509AbYJGUg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 16:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754556AbYJGUgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 16:36:10 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:47670 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757444AbYJGUgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 16:36:07 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <gregkh@suse.de>
Cc: Mark Ryden <markryde@gmail.com>, Benjamin Thery <benjamin.thery@bull.net>,
       David Shwatrz <dshwatrz@gmail.com>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <htejun@gmail.com>,
       Daniel Lezcano <dlezcano@fr.ibm.com>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>, netdev@vger.kernel.org
References: <20080820021754.GA25182@kroah.com>
	<m1od3m282j.fsf_-_@frodo.ebiederm.org>
	<m1hc9e27ya.fsf_-_@frodo.ebiederm.org> <48B57058.9000101@bull.net>
	<dac45060809020654g62afb3c9yd104682b93b43bee@mail.gmail.com>
	<48BD47A8.1080909@bull.net> <20080902170148.GA9305@suse.de>
	<31436f4a0809032233r2c46de8od8a94460ce3b5ed2@mail.gmail.com>
	<48BF83E1.5040000@bull.net>
	<dac45060810070939v80918a0m3963d7fc6fcbb975@mail.gmail.com>
	<20081007164833.GA16056@suse.de>
Date: Tue, 07 Oct 2008 13:31:52 -0700
In-Reply-To: <20081007164833.GA16056@suse.de> (Greg KH's message of "Tue, 7
	Oct 2008 09:48:33 -0700")
Message-ID: <m1abdgywnb.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg KH <gregkh@suse.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.1532]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 1/8] sysfs: Implement sysfs tagged directory support.
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

> On Tue, Oct 07, 2008 at 06:39:04PM +0200, Mark Ryden wrote:
>> Hello,
>>   So I wonder: the sysfs tagged directory support patch is in GerKH
>> tree for more than a month.
>
> I dropped it from my tree 2 days ago, see the thread on lkml for why.

Greg why did you drop it? 

Eric

