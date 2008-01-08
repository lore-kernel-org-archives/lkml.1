Return-Path: <linux-kernel-owner+w=401wt.eu-S1760592AbYAHQGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760592AbYAHQGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 11:06:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753008AbYAHQGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 11:06:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56733 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039AbYAHQGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 11:06:33 -0500
Date: Tue, 8 Jan 2008 17:06:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Martin Bligh <mbligh@mbligh.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, bugme-admin@linux-foundation.org,
       Peter Osterlund <petero2@telia.com>
Subject: Re: change SCSI owner in bugzilla
Message-ID: <20080108160607.GA32273@elte.hu>
References: <20080106161635.GL2082@does.not.exist> <47828CC7.7060106@mbligh.org> <200801072147.53011.rjw@sisk.pl> <20080108100752.GA6906@elte.hu> <47839D3C.1090106@mbligh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47839D3C.1090106@mbligh.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Martin Bligh <mbligh@mbligh.org> wrote:

>>> BTW, would that be possible to forward messages sent to
>>> power-management_other@kernel-bugs.osdl.org to
>>> linux-pm@lists.linux-foundation.org?
>>
>> stupid question: why isnt this done via what most maintainers do, to 
>> set up your bugzilla account to generate notifications of the special 
>> power-management_other@kernel-bugs.osdl.org bugzilla user?
>
> That would be better. Creating "users" for mailing lists may be 
> problematic - if it is, let me know.

for those who have not set that up yet, it's in:

  Edit / Prefs / Email Preferences / Users to watch

add power-management_other@kernel-bugs.osdl.org to that list and you'll 
be notified about new bugs and changes to existing bugs.

	Ingo
