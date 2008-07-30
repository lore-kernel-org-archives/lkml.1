Return-Path: <linux-kernel-owner+w=401wt.eu-S1752835AbYG3Iih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbYG3Iih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 04:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759188AbYG3Ii1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 04:38:27 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:37451 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759182AbYG3Ii0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 04:38:26 -0400
Message-ID: <4890284E.3050806@s5r6.in-berlin.de>
Date: Wed, 30 Jul 2008 10:37:34 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Rene Herman <rene.herman@keyaccess.nl>, Jon Smirl <jonsmirl@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>, James Morris <jmorris@namei.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Dave Jones <davej@redhat.com>,
       Theodore Tso <tytso@mit.edu>, Simon Arlott <simon@fire.lp0.eu>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: 463 kernel developers missing!
References: <9e4733910807281200m25f7f16bwa6678694bb25a61@mail.gmail.com> <20080728202236.GN9378@mit.edu> <20080728204624.GA11581@redhat.com> <20080728141414.d7e5def2.randy.dunlap@oracle.com> <Xine.LNX.4.64.0807290751510.31732@us.intercode.com.au> <20080728234131.GD28055@linux-sh.org> <9e4733910807281714h2918fcbey77c8d1cea902a3fd@mail.gmail.com> <488E644D.7000507@keyaccess.nl> <9e4733910807281750p52cf150lacd0e237732046e7@mail.gmail.com> <488EF377.5080603@keyaccess.nl> <20080730072448.GB1564@cs181140183.pp.htv.fi>
In-Reply-To: <20080730072448.GB1564@cs181140183.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> Whether Jon's patch is a good idea one might discuss,

There isn't a lot to discuss.  From a purely technical standpoint,
duplicating SCM metadata into a source file and aiming to be
comprehensive and up to date is naive at best.

> but as soon as someone puts an email address into a kernel commit
> Google will anyway find it:

This doesn't justify what Jon did though.

Jon created a new database out of formerly disparate datasets, even
though we didn't provide him these datasets for this purpose.  The fact
that the means to create this database are rather trivial and cheap do
not mean that we implicitly agreed to what he did or that it wouldn't
matter whether we agree to it or not.

Jon even suggested that his database is then used to combine with
further databases (bugzilla accounts, mailinglist archives).  Again, the
fact that something like this is possible without great difficulties
doesn't make it right.
-- 
Stefan Richter
-=====-==--- -=== ====-
http://arcgraph.de/sr/
