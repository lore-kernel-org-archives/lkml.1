Return-Path: <linux-kernel-owner+w=401wt.eu-S1752565AbZL2BTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbZL2BTw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 20:19:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383AbZL2BTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 20:19:51 -0500
Received: from lists.laptop.org ([18.85.2.145]:55851 "EHLO mail.laptop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751638AbZL2BTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 20:19:50 -0500
Date: Mon, 28 Dec 2009 20:21:58 -0500
From: Michael Stone <michael@laptop.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-security-module@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       David Lang <david@lang.hm>, Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Bryan Donlan <bdonlan@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Samir Bellabes <sam@synack.fr>,
       Casey Schaufler <casey@schaufler-ca.com>, Pavel Machek <pavel@ucw.cz>,
       Michael Stone <michael@laptop.org>
Subject: Re: [PATCH 1/3] Security: Add disablenetwork interface. (v4)
Message-ID: <20091229012158.GA14362@heat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20091228181357.GB16277@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge Hallyn wrote:
> Is there any reason not to handle these in
>   disablenetwork_security_prctl()
> ?

I'm afraid that I don't understand what you're asking here. Are you just saying
that you'd like me to rename the functions that implement the interface logic
to something that begins with "disablenetwork_"?

Regards, and thanks for all your help,

Michael
