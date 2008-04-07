Return-Path: <linux-kernel-owner+w=401wt.eu-S1758734AbYDGW5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734AbYDGW5d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 18:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674AbYDGW5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 18:57:22 -0400
Received: from web36601.mail.mud.yahoo.com ([209.191.85.18]:29995 "HELO
	web36601.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753324AbYDGW5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 18:57:20 -0400
X-YMail-OSG: qJERYgQVM1mhNI_4PgYdjxxW9QI7DqSu6ieAuV1SzLAqcA6Kr19ycPfoZbaHpRcNH9xsiCRHHQ--
X-RocketYMMF: rancidfat
Date: Mon, 7 Apr 2008 15:57:16 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [TOMOYO #7 30/30] Hooks for SAKURA and TOMOYO.
To: Paul Moore <paul.moore@hp.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Kentaro Takeda <takedakn@nttdata.co.jp>,
       Toshiharu Harada <haradats@nttdata.co.jp>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-netdev <netdev@vger.kernel.org>
In-Reply-To: <200804071140.59247.paul.moore@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <312131.8802.qm@web36601.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Paul Moore <paul.moore@hp.com> wrote:

> On Friday 04 April 2008 8:23:12 am Tetsuo Handa wrote:
> > This file contains modifications against kernel source code
> > needed to use TOMOYO Linux 1.6.
> >
> > Although LSM hooks are provided for performing access control,
> > TOMOYO Linux 1.6 doesn't use LSM because of the following reasons.
> 
> Hello,
> 
> I understand your frustration with the existing LSM hooks/API and your 
> reasoning for abandoning LSM in favor of a new set of hooks, however, I 
> think this sets a dangerous precedence which could result in an 
> abundance of security related hooks scattered throughout the kernel.  I 
> would much rather see the LSM API extended/tweaked to support the needs 
> of SAKURA and TOMOYO than ignored and duplicated; I suspect several 
> others will say the same.

The same.



Casey Schaufler
casey@schaufler-ca.com
