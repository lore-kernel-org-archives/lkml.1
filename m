Return-Path: <linux-kernel-owner+w=401wt.eu-S1756244AbYGOSht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbYGOSht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 14:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757954AbYGOSh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 14:37:27 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:3814 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757067AbYGOShZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 14:37:25 -0400
Date: Tue, 15 Jul 2008 14:26:54 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: REVISED AGENDA -- Re: Linux Wireless Mini-Summit -- Ottawa -- July
	22, 2008
Message-ID: <20080715182654.GA5969@tuxdriver.com>
References: <20080709190915.GA8238@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080709190915.GA8238@tuxdriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I revised the agenda based on the feedback from last week.
Most changes are fairly minor, although I moved the vendor/distro
round table after lunch to give us a chance to cover some in-progress
work beforehand.

As I mentioned elsewhere in the thread, I don't think we have enough
time for work sessions on Tuesday.  As others have pointed-out, there
is plenty of time for extended discussions during the days at OLS.
So I think we should keep Tuesday for more high-level design and
development process discussions.

Feel free to volunteer to cover any of the listed topics.  Further
suggestions to alter or augment the agenda are, of course, still
welcome as well.

Thanks!

John

---

3rd Linux Wireless Summit
Ottawa, Canada
22 July 2008

Proposed Agenda

0830	Meet & Greet

	Introductions and opening remarks

0900	Status Reports

	Overview of where things stand today

	- 802.11n

	- QoS/Multiqueue

	- spectrum management

	- Mesh mode (802.11s)

	- RF kill

1015	Break

1030	Current Work

	Short presentations/discussions about work in progress

	- access point mode

	- cfg80211/nl80211
		- time to push to replace WEXT?
		- tool enhancements and/or userland support?

	- regulatory enforcement (802.11d, CRDA)

	- encrypted management frames (802.11w)

	- virtual hardware (mac80211_hwsim)

	- WiMAX

1200	Lunch/Break (provided by HP)

1300	Vendor/Distro Round Table

	Representatives from hardware vendors and Linux distributions
	discuss issues around cooperation between themselves and the
	development community, what we are doing well, and what problems we
	are causing for each other.

1445	Break

1500	Future work

	Short presentations/discussions about work that has previously
	been suggested or requested

	- power management 
		- suspend/resume
		- power savings

	- lib80211 (code sharing w/ full MAC drivers)

	- rate scaling algorithms
		- minstrel
		- others?

	- userland MLME

	- userland driver implementation

	- organized testing?

1645	Break

1700	Maintainence Issues

	Round table discussion of issues related to maintenance of
	the wireless trees

	- trivial/cleanup patches
		- testing or other requirements?
		- should they have lower priority?
		- should they require ACKs from primary author?

	- submissions to -stable
		- who should drive it?
		- what policies?

	- rate scaling algs
		- driver-specific ok?  what limitations?
		- build policies (part of mac80211.ko?)

	- questions/suggestions/complaints

1800	Dinner/Break (sorry, no funding)

2000	BoF/Break-out Sessions

	Impromptu and/or unscheduled discussions as desired by group
	participants

-- 
John W. Linville
linville@tuxdriver.com
