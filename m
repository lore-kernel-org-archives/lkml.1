Return-Path: <linux-kernel-owner+w=401wt.eu-S1754982AbYJHJCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbYJHJCv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 05:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754318AbYJHJCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 05:02:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36673 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753895AbYJHJCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 05:02:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Miller <davem@davemloft.net>
Subject: Re: Top kernel oopses/warnings for the week of October 7th, 2008
Date: Wed, 8 Oct 2008 11:06:54 +0200
User-Agent: KMail/1.9.9
Cc: alan@lxorguk.ukuu.org.uk, arjan@linux.intel.com,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, mingo@elte.hu, netdev@vger.kernel.org,
       linux-acpi@vger.kernel.org, tglx@tglx.de, tytso@mit.edu,
       linux-ide@vger.kernel.org
References: <48EBBE15.9030905@linux.intel.com> <20081007235833.1a89948f@lxorguk.ukuu.org.uk> <20081007.160835.257227518.davem@davemloft.net>
In-Reply-To: <20081007.160835.257227518.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810081106.55730.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 8 of October 2008, David Miller wrote:
> From: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Date: Tue, 7 Oct 2008 23:58:33 +0100
> 
> > > This should have been fixed by:
> > > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f5a6d958b5d0a10e7e7a9dee1862fb31d08c6d26
> > 
> > You mean - hidden by - that change should IMHO be reverted
> 
> Grrr... I totally agree.

Even though they are false positives in many cases?

(Yes, they are).
