Return-Path: <linux-kernel-owner+w=401wt.eu-S1753122AbZHPR1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122AbZHPR1E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 13:27:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbZHPR1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 13:27:04 -0400
Received: from smtp104.prem.mail.sp1.yahoo.com ([98.136.44.59]:27083 "HELO
	smtp104.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750857AbZHPR1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 13:27:03 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: xSbeth4VM1mSlxH.iJP56WH.Qb63SzFx17eo5CJ7uapjm.Rl06.tZCZR25uaCXfl8ai_5uehpgC5PlAN8I6ARPWtl8chlgVC3M8WCRJ5jYft7XpXwQIFxS14lHC1p14DYBdhxhuzO4mqICeAlkLG0PFtDNx8ncAzkZu.TE65bVcHSCUD0jlqI3EIogRCVtUxmX.y26Q60t08wFXGWGRsa..M4UzJgHYgXUBU4E83.cLmUDMELLgGoK_FZjdkdQHV..jb0E320XGqKGG7CcdeBRo9oj7efUENbLWqaXOxA.hDTXzhX9cjZX8pFm0iAXHrAYuL
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4A8840F3.5040203@schaufler-ca.com>
Date: Sun, 16 Aug 2009 10:25:07 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "David P. Quigley" <dpquigl@tycho.nsa.gov>, jmorris@namei.org,
       Stephen Smalley <sds@tycho.nsa.gov>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       selinux@tycho.nsa.gov
Subject: Re: [PATCH] Security/sysfs: Enable security xattrs to be set on sysfs
 files, directories, and symlinks.
References: <1247665721-2619-1-git-send-email-dpquigl@tycho.nsa.gov>	<4A84EF1D.8060408@schaufler-ca.com> <m1my62xde6.fsf@fess.ebiederm.org>	<4A861291.1030404@schaufler-ca.com> <m1tz09j00q.fsf@fess.ebiederm.org>	<4A864008.50907@schaufler-ca.com> <m1my61sjie.fsf@fess.ebiederm.org>
In-Reply-To: <m1my61sjie.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
>
> If it is a valid optimization to inter atoms as the labels and just
> hold a couple.  I think the implementation is roughly comparable in
> size/complexity with what you have now, and likely to be a nicer in
> the common case for the people who want to do play with labels and
> sysfs.
>   

I have a notion for a different approach that might make everyone
happier. It may take a few days.

working ...


