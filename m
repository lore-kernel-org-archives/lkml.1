Return-Path: <linux-kernel-owner+w=401wt.eu-S1760146AbYGSAAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760146AbYGSAAd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 20:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756801AbYGSAAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 20:00:22 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:3900 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753624AbYGSAAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 20:00:21 -0400
Date: Fri, 18 Jul 2008 19:23:21 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: 3rd REVISED AGENDA -- Re: Linux Wireless Mini-Summit -- Ottawa --
	July 22, 2008
Message-ID: <20080718232321.GA12961@tuxdriver.com>
References: <20080709190915.GA8238@tuxdriver.com> <20080715182654.GA5969@tuxdriver.com> <20080716184803.GB3232@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080716184803.GB3232@tuxdriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One more adjustment to account for change in the lunch schedule.

John

---

3rd Linux Wireless Summit
Les Suites Hotel, Byward Suite
Ottawa, Canada
22 July 2008

Proposed Agenda

0830	Meet & Greet

	Introductions and opening remarks

0900	Status Reports

	Overview of where things stand today

	- QoS/Multiqueue

	- 802.11n

	- spectrum management

	- Mesh mode (802.11s)

	- RF kill

	- driver status reports

1000	Break

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

1200	Vendor/Distro Round Table

	Representatives from hardware vendors and Linux distributions
	discuss issues around cooperation between themselves and the
	development community, what we are doing well, and what problems we
	are causing for each other.

1230	Lunch/Break (provided)

1400	Future work

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

	- organized testing (anyone have a proposal?)

1530	BoF/Break-out/BarCamp Session Proposals

1600	Break

1630	BoF/Break-out/BarCamp Sessions

	Impromptu and/or unscheduled discussions as desired by group
	participants

1800	BoF/Break-out/BarCamp Session Reports

1830	Maintainence Issues

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

1900	Adjourn
-- 
John W. Linville
linville@tuxdriver.com
