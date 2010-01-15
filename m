Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab0AOIIR (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 03:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752961Ab0AOIIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 03:08:13 -0500
Received: from lists.laptop.org ([18.85.2.145]:44384 "EHLO mail.laptop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752712Ab0AOIII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 03:08:08 -0500
Date: Fri, 15 Jan 2010 03:10:28 -0500
From: Michael Stone <michael@laptop.org>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, David Lang <david@lang.hm>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
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
        Casey Schaufler <casey@schaufler-ca.com>,
        "Serge E. Hallyn" <serue@us.ibm.com>, Pavel Machek <pavel@ucw.cz>,
        Al Viro <viro@ZenIV.linux.org.uk>, Kyle Moffett <kyle@moffetthome.net>,
        Andrew Morgan <morgan@kernel.org>, Michael Stone <michael@laptop.org>
Subject: disablenetwork (v5) patches
Message-ID: <20100115081028.GA14004@heat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20100114173639.GA15587@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As promised, here are patches implementing and documenting a CAP_SETPCAP-gated
"enable" bit along with a couple of other tweaks discussed earlier in the
thread. For ease of development and review, the following four patches extend
the disablenetwork (v4) patch series rather than replacing it. 

Enjoy,

Michael
