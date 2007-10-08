Return-Path: <linux-kernel-owner+w=401wt.eu-S1753373AbXJHU7D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbXJHU7D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 16:59:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbXJHU6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 16:58:53 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:36639 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbXJHU6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 16:58:52 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: casey@schaufler-ca.com
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Kyle Moffett <mrmacman_g4@mac.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access Control Kernel
References: <868078.46629.qm@web36612.mail.mud.yahoo.com>
Date: Mon, 08 Oct 2007 14:57:27 -0600
In-Reply-To: <868078.46629.qm@web36612.mail.mud.yahoo.com> (Casey Schaufler's
	message of "Mon, 8 Oct 2007 13:25:58 -0700 (PDT)")
Message-ID: <m18x6d1g08.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> writes:

> --- "Eric W. Biederman" <ebiederm@xmission.com> wrote:
>
>> It really seems to me that the LSM as currently structured creates
>> a large barrier to entry for people who have just this little thing
>> they want to do that is not possible with any existing security
>> module.
>
> I honestly think that the barrier has been more political
> in nature than technical. I don't know how long you've been
> watching, but no attempt to get an LSM upstream has escaped
> exagerated cricism from certain factions. Only someone who wants
> to get cut to metaphorical ribbons would submit a little LSM.
> Maybe that will get better now. I sure hope so.

Yes.  Me to.  I certainly agree about the political part.

My only hope was to suggest something that my reduce what there is to
get political about.

Eric
