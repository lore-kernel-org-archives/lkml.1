Return-Path: <linux-kernel-owner+w=401wt.eu-S1764872AbZLQQ0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764872AbZLQQ0p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 11:26:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761695AbZLQQ0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 11:26:40 -0500
Received: from lists.laptop.org ([18.85.2.145]:54189 "EHLO mail.laptop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761484AbZLQQ0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 11:26:38 -0500
Date: Thu, 17 Dec 2009 11:28:34 -0500
From: Michael Stone <michael@laptop.org>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Michael Stone <michael@laptop.org>, Ulrich Drepper <drepper@gmail.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
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
       Mark Seaborn <mrs@mythic-beasts.com>
Subject: Re: [PATCH] Security: Add prctl(PR_{GET,SET}_NETWORK) interface.
Message-ID: <20091217162834.GA3047@heat>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2375c9f90912170125u6de30803sd80ecddaa332cc6a@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Américo Wang wrote:

> Any reason why you introdce a new source file?
> Why not just adding them to kernel/sys.c?

Modifying kernel/sys.c would be fine too, I think. I'll incorporate this
suggestion into the next revision of the prctl()-based patches.

Thanks!

Michael
