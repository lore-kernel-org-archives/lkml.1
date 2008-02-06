Return-Path: <linux-kernel-owner+w=401wt.eu-S1760186AbYBFVA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760186AbYBFVA3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 16:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757520AbYBFVAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 16:00:15 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58794 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757322AbYBFVAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 16:00:14 -0500
Date: Wed, 6 Feb 2008 22:00:26 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Cc: ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org,
       "Zhu, Yi" <yi.zhu@intel.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: ipw3945: not only it periodically dies, it also BUG()s
Message-ID: <20080206210026.GA32641@elf.ucw.cz>
References: <20080205214441.GA1518@elf.ucw.cz> <D936D925018D154694D8A362EEB0892003982BB1@orsmsx416.amr.corp.intel.com> <20080206143218.GA16188@elf.ucw.cz> <D936D925018D154694D8A362EEB0892003982E4C@orsmsx416.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D936D925018D154694D8A362EEB0892003982E4C@orsmsx416.amr.corp.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>> ...I've reported this before, with full debugging. Not sure if
> >>> anything happened.
> >> 
> >> Could you please point me to where you have reported it before?
> > 
> > From pavel@ucw.cz Wed Oct 31 01:52:02 2007
> > From: Pavel Machek <pavel@ucw.cz>
> > To: linux-wireless@vger.kernel.org,
> >        kernel list <linux-kernel@vger.kernel.org>,
> >        ipw3945-devel@lists.sourceforge.net, yi.zhu@intel.com
> > Subject: iwl3945 in 2.6.24-rc1 dies under load
> > X-Warning: Reading this can be dangerous to your mental health.
> > 
> > ...and thread that resulted.
> 
> Could you please create a new bug in our bug tracking system
> (www.bughost.org) to enable us to track this problem? Please include the
> relevant information from the thread as well as the information you
> doscovered recently.

Hmmm... bugzilla says:

    * Exact steps to reproduce
    * Reproducability of bug (e.g. intermittent or 100% reproducable)
    * Did this problem not exist in previous version of the driver?
    * kernel version
    * AP brand/model
    * dmesg output at debug level 0x43fff
      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		it would be nice to specify how to do this. It is
insmod parameter, right?

    * Type of security (if any) you are using (e.g. WEP64, WEP128, WPA, WPA2, 802.1x, etc)
    * Version of firmware
    * Version of the ieee80211 module
    * Proximity to the AP

    * Before reporting any firmware errors, please be sure to read Ben
Cahill's mailing list post on how to most effectively report such
bugs. 
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		unfortunately the link here does not work.

BTW, why not use kernel.org bugzilla? Having to create another account
is nasty...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
