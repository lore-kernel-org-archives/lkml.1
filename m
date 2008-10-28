Return-Path: <linux-kernel-owner+w=401wt.eu-S1753447AbYJ1UTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbYJ1UTa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 16:19:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbYJ1UTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 16:19:18 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:53546 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751041AbYJ1UTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 16:19:17 -0400
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
cc: Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       NetDEV list <netdev@vger.kernel.org>,
       "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Subject: Re: e1000e fails after several S3 resumes (2.6.26 Debian, TP T60) 
In-Reply-To: Your message of "Fri, 24 Oct 2008 09:22:58 PDT."
             <F169D4F5E1F1974DBFAFABF47F60C10A069DFFA0@orsmsx507.amr.corp.intel.com> (sfid-20081024_142044_698098_A035A635) 
X-Mailer: MH-E 8.1; nmh 1.2; GNU Emacs 22.2.1
Date: Tue, 28 Oct 2008 16:18:48 -0400
From: Sanjoy Mahajan <sanjoy@MIT.EDU>
Message-Id: <E1Kuv1c-00033M-Ia@approx.mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think you should definitely try 2.6.27.y, the e1000e versions in the
> kernel are different than what is in ubuntu at least, so not sure if
> that applies to debian.

I'm running 2.6.27.4, and I haven't seen the e1000e problem yet.  But it
happens quite often with wlan0 (iwl3945), whereupon unloading and
loading the module fixes it.

Is there an analogue of ethtool for wireless cards (for debugging and
resetting a la 'ethtool -r eth0'?  Other than the tcpdump, what
debugging information should I collect for iwl3945?  And who should I
add/remove from the CC before sending it out?

-Sanjoy

`Until lions have their historians, tales of the hunt shall always
 glorify the hunters.'  --African Proverb
