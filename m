Return-Path: <linux-kernel-owner+w=401wt.eu-S1757062AbZJCTfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062AbZJCTfp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 15:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756891AbZJCTfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 15:35:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39664 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756890AbZJCTfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 15:35:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 01/19] freezer: don't get over-anxious while waiting
Date: Sat, 3 Oct 2009 21:36:36 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc2-rjw; KDE/4.3.1; x86_64; ; )
Cc: Matt Helsley <matthltc@us.ibm.com>, Oren Laadan <orenl@librato.com>,
       Pavel Machek <pavel@ucw.cz>, jeff@garzik.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       jens.axboe@oracle.com, rusty@rustcorp.com.au, cl@linux-foundation.org,
       dhowells@redhat.com, arjan@linux.intel.com,
       pm list <linux-pm@lists.linux-foundation.org>
References: <1254384558-1018-1-git-send-email-tj@kernel.org> <200910022321.11796.rjw@sisk.pl> <4AC69E3F.80301@kernel.org>
In-Reply-To: <4AC69E3F.80301@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910032136.36691.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 October 2009, Tejun Heo wrote:
> Hello, Rafael.
> 
> Rafael J. Wysocki wrote:
> > Tejun, do you want me to take the patch or is it more convenient to you to
> > push it yourself?
> 
> Please take the patch.  As long as it's in a stable git tree, it
> should be fine for me.

OK, I'll put it into suspend-2.6/for-linus, but first it'll stay in
suspend-2.6/linux-next for a few days.

> > Also, care to respond to my previous comment?
> 
> About the comment?  Dropping it is fine.  Do you want me to resend the
> patch w/o the comment?

No, thanks. 

Best,
Rafael
