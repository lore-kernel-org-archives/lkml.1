Return-Path: <linux-kernel-owner+w=401wt.eu-S1752850AbYHGObl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbYHGObl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 10:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbYHGObd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 10:31:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbYHGObc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 10:31:32 -0400
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a
	linuxinterfaceforon access scanning
From: Eric Paris <eparis@redhat.com>
To: Peter Dolding <oiaohm@gmail.com>
Cc: Pavel Machek <pavel@suse.cz>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       linux-security-module@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <e7d8f83e0808070721l2dd38f0dyd0366520e9131b1a@mail.gmail.com>
References: <20080806064418.6afa0672@infradead.org>
	 <20080806141656.8B44B2FE94A@pmx1.sophos.com>
	 <20080807092800.GA22222@atrey.karlin.mff.cuni.cz>
	 <e7d8f83e0808070721l2dd38f0dyd0366520e9131b1a@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 07 Aug 2008 10:31:23 -0400
Message-Id: <1218119483.5837.112.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-08 at 00:21 +1000, Peter Dolding wrote:

> Also TALPA is wrong because its a LSM.   LSM are the most powerful
> bits of the OS.   LSM are the enforcers of Linux.  They are the last
> line of defence for the OS.   You have your normal permission systems
> when they fail then its the job of a LSM to pick up the mess.

I've been trying to ignore you, but I just can't any more.  Please dear
god look at my work before spewing this crap.  My work is not an LSM.
My work doesn't care about bind mounts, it cares about inodes.  My work
is not path name based.  I'm not sure who you are trying to convince of
something here but obviously talking about something you don't know
about is not working for you.....

-Eric

