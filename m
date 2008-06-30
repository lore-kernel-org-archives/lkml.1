Return-Path: <linux-kernel-owner+w=401wt.eu-S1755459AbYF3DLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbYF3DLo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 23:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751273AbYF3DLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 23:11:36 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:44921 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbYF3DLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 23:11:35 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tejun Heo <htejun@gmail.com>
Cc: Benjamin Thery <benjamin.thery@bull.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>
References: <20080618170729.808539948@theryb.frec.bull.fr>
	<20080618170731.153832341@theryb.frec.bull.fr>
	<485F06B8.6090902@gmail.com> <m1od5ovt9s.fsf@frodo.ebiederm.org>
	<48670308.5020301@gmail.com>
Date: Sun, 29 Jun 2008 20:02:22 -0700
In-Reply-To: <48670308.5020301@gmail.com> (Tejun Heo's message of "Sun, 29 Jun
	2008 12:35:36 +0900")
Message-ID: <m18wwnvd4x.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tejun Heo <htejun@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0132]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 07/11] sysfs: Implement sysfs_delete_link and sysfs_rename_link
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <htejun@gmail.com> writes:
>
> I think the current one should do for now.  Changing to managed links
> requires pervasive changes to locking and stuff.  I'll clean them up
> when I refresh the patches I posted a while back.

Sounds good.

Eric
