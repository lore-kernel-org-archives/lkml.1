Return-Path: <linux-kernel-owner+w=401wt.eu-S1762790AbYBTUD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762790AbYBTUD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:03:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757732AbYBTUDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:03:47 -0500
Received: from web36614.mail.mud.yahoo.com ([209.191.85.31]:48769 "HELO
	web36614.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757531AbYBTUDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:03:46 -0500
X-YMail-OSG: qg4ZYB0VM1mjxw52KUALIqgDMZvE8bC7.LQMdIYgKqUC6BJApNygkt8FreGjRYfhRA--
X-RocketYMMF: rancidfat
Date: Wed, 20 Feb 2008 12:03:42 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] (linus git 02/19/08) Smack update for file capabilities
To: "Serge E. Hallyn" <serue@us.ibm.com>,
       Casey Schaufler <casey@schaufler-ca.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
In-Reply-To: <20080220175051.GA16489@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <143991.28519.qm@web36614.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- "Serge E. Hallyn" <serue@us.ibm.com> wrote:

> Quoting Casey Schaufler (casey@schaufler-ca.com):
> > From: Casey Schaufler <casey@schaufler-ca.com>
> >
> > Update the Smack LSM to allow the registration of the capability
> > "module" as a secondary LSM. Integrate the new hooks required for
> > file based capabilities.
> 
> Hi Casey,
> 
> to help people keep their mailboxes straight it'd be good to have a
> changelog here pointing out that you addressed Stephen's point.

Thanks for the reminder.

> Looks good to me.  It's too bad the logic has to be quite so convoluted
> between the two, but I'm not sure it can be improved upon...

It's not so bad.

> And thanks Stephen, I well might have missed the issue you pointed out.

Indeed. The careful review is much appreciated.


Casey Schaufler
casey@schaufler-ca.com
