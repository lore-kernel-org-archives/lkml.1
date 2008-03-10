Return-Path: <linux-kernel-owner+w=401wt.eu-S1753407AbYCJSoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbYCJSoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 14:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbYCJSnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 14:43:52 -0400
Received: from web36607.mail.mud.yahoo.com ([209.191.85.24]:23098 "HELO
	web36607.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751463AbYCJSnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 14:43:51 -0400
X-YMail-OSG: I.L36T8VM1nEmJfX5fonlfwIEV_mvicpMFKKE8ifEg1ge_4BxYtFBLJGna0QlzPTNtCrcxiGDA--
X-RocketYMMF: rancidfat
Date: Mon, 10 Mar 2008 11:43:50 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [RFC][PATCH] Smack<->Audit integration
To: "Ahmed S. Darwish" <darwish.07@gmail.com>,
       Casey Schaufler <casey@schaufler-ca.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Paul Moore <paul.moore@hp.com>,
       LKML <linux-kernel@vger.kernel.org>,
       LSM-ML <linux-security-module@vger.kernel.org>,
       Audit-ML <linux-audit@redhat.com>
In-Reply-To: <20080310182634.GA448@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <728222.69530.qm@web36607.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- "Ahmed S. Darwish" <darwish.07@gmail.com> wrote:

> ...
> > 
> 
> You've meant using the short-circuit:
> 	 smk_rule->smk_smack == smack || strnmp(smack, ..., ..)
> Right ?

Yes, that's the safe approach.

Thank you.


Casey Schaufler
casey@schaufler-ca.com
