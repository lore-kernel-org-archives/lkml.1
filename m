Return-Path: <linux-kernel-owner+w=401wt.eu-S935547AbZLGRdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935547AbZLGRdy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 12:33:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935509AbZLGRdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 12:33:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49899 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935529AbZLGRdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 12:33:52 -0500
Message-ID: <4B1D3CCB.5000607@gmail.com>
Date: Mon, 07 Dec 2009 18:35:07 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: lenb@kernel.org, astarikovskiy@suse.de, mchehab@infradead.org,
       linville@tuxdriver.com, miklos@szeredi.hu, davem@davemloft.net,
       rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
       avi@redhat.com, mtosatti@redhat.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 11/31] Constify struct file_operations for 2.6.32 v1
References: <4B198670.2000406@gmail.com> <4B198C43.50205@gmail.com> <4B19A333.5080103@gmail.com> <20091205000942.GA8224@suse.de> <4B19CA6F.4090700@gmail.com> <20091205041507.GA24885@suse.de> <4B1B0D40.3040209@gmail.com> <20091206172526.GA17480@suse.de> <4B1C500E.5040406@gmail.com> <20091207151156.GA27574@suse.de>
In-Reply-To: <20091207151156.GA27574@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> From: Emese Revfy <re.emese@gmail.com>
>>
>> Constify struct file_operations with some exceptions.
> 
> Now please break this patch (and your others) out into "one subsystem at
> a time" type thing so it will have a chance at being applied.

Shall i split them up per subsystem and structure type or
only per subsystem (that is, include all affected structures
in the given subsystem)?
--
Emese

