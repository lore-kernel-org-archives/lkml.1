Return-Path: <linux-kernel-owner+w=401wt.eu-S932707AbYEAV74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932707AbYEAV74 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 17:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761531AbYEAV7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 17:59:46 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:47606 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757232AbYEAV7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 17:59:45 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Greg KH <gregkh@suse.de>, Benjamin Thery <benjamin.thery@bull.net>,
       linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>,
       Tejun Heo <htejun@gmail.com>, Daniel Lezcano <dlezcano@fr.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, netdev@vger.kernel.org
References: <20080429171015.473938697@theryb.frec.bull.fr>
	<20080429173621.GA16625@suse.de>
	<20080429180445.GA18110@sergelap.austin.ibm.com>
	<20080429184151.GA19794@suse.de>
	<20080429193417.GA19282@sergelap.austin.ibm.com>
	<20080501031341.GD4911@suse.de>
	<20080501151051.GB16038@sergelap.austin.ibm.com>
	<m11w4lho08.fsf@frodo.ebiederm.org>
	<20080501210550.GA22534@sergelap.austin.ibm.com>
Date: Thu, 01 May 2008 14:58:46 -0700
In-Reply-To: <20080501210550.GA22534@sergelap.austin.ibm.com> (Serge
	E. Hallyn's message of "Thu, 1 May 2008 16:05:50 -0500")
Message-ID: <m1prs5fzzd.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0052]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 00/10] sysfs tagged directories
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serue@us.ibm.com> writes:

> Quoting Eric W. Biederman (ebiederm@xmission.com):

> Ok as it turns out Benjamin Thery does in fact have a patch to fix this.
> Benjamin, please send your renaming patch out tomorrow if you can?
>
> I guess this is why I didn't really see the problem Benjamin said there
> was - it just works with SYSFS_DEPRECATED  :)

It will be nice to see that patch.  I'm curious what the problem was.

Eric
