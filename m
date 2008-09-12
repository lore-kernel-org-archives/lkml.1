Return-Path: <linux-kernel-owner+w=401wt.eu-S1757442AbYILTMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442AbYILTMj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 15:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754981AbYILTMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 15:12:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42363 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754843AbYILTMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 15:12:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: 2.6.27-rc6: nohz + s2ram = need to press keys to get progress
Date: Fri, 12 Sep 2008 21:17:04 +0200
User-Agent: KMail/1.9.9
Cc: kernel list <linux-kernel@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.osdl.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
References: <20080912083113.GA1625@elf.ucw.cz>
In-Reply-To: <20080912083113.GA1625@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809122117.05750.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 12 of September 2008, Pavel Machek wrote:
> Hi!
> 
> The old "you have to press keys to get machine to progress" seems to
> be back :-(. Thinkpad x60.

I guess the last bunch of HPET/clockevents patches caused that to happen.

We seem to be doing a "one step forward, one step back" thing here ...

Thanks,
Rafael
