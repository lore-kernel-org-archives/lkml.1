Return-Path: <linux-kernel-owner+w=401wt.eu-S1755956AbZADQDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956AbZADQDM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 11:03:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbZADQCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 11:02:55 -0500
Received: from mail001.aei.ca ([206.123.6.130]:33540 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756AbZADQCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 11:02:54 -0500
From: Ed Tomlinson <edt@aei.ca>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: Btrfs for mainline
Date: Sun, 4 Jan 2009 10:56:07 -0500
User-Agent: KMail/1.9.10
Cc: Roland Dreier <rdreier@cisco.com>, Chris Mason <chris.mason@oracle.com>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "linux-fsdevel" <linux-fsdevel@vger.kernel.org>,
       "linux-btrfs" <linux-btrfs@vger.kernel.org>
References: <1230932112.7538.82.camel@think.oraclecorp.com> <adaocyppco5.fsf@cisco.com> <20090104222638.C7FD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20090104222638.C7FD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901041056.07714.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On January 4, 2009, KOSAKI Motohiro wrote:
> Hi
> 
> > One possibility would be to mimic ext4 and register the fs as "btrfsdev"
> > until it's considered stable enough for production.  I agree with the
> > consensus that we want to use the upstream kernel as a nexus for
> > coordinating btrfs development, so I don't think it's worth waiting a
> > release or two to merge something.
> 
> I like this idea.
> I also want to test btrfs. but I'm not interested out of tree code.

I'll second this.  Please get btrfsdev into mainline asap.

TIA
Ed Tomlinson
