Return-Path: <linux-kernel-owner+w=401wt.eu-S1755180AbYIWWST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbYIWWST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 18:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbYIWWSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 18:18:09 -0400
Received: from styx.suse.cz ([82.119.242.94]:47242 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750966AbYIWWSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 18:18:08 -0400
Date: Wed, 24 Sep 2008 00:19:00 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
cc: David Miller <davem@davemloft.net>, airlied@gmail.com,
       david.vrabel@csr.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, chrisl@vmware.com
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
In-Reply-To: <9929d2390809231512w160d221axa2923a6b293a041@mail.gmail.com>
Message-ID: <alpine.LNX.1.10.0809240014390.4671@pegasus.suse.cz>
References: <alpine.LNX.1.10.0809231229460.4671@pegasus.suse.cz>  <20080923.140519.268233735.davem@davemloft.net>  <21d7e9970809231409r3fdd640h53a72a808266d220@mail.gmail.com>  <20080923.150722.141587696.davem@davemloft.net>
 <9929d2390809231512w160d221axa2923a6b293a041@mail.gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2008, Jeff Kirsher wrote:

> >> I don't think OpenSUSE was shipping any of the GEM bits.
> > Good data point, can someone confirm this?  Also, what X server version
> > is the effected OpenSUSE shipping?
> OpenSuSE 11 ships x server version 7.3.

Opensuse 11 is fine.

The problem can be reproduced [not only] on opensuse 11.1 beta1, which has

	xorg-x11-7.4-1.6.x86_64.rpm

-- 
Jiri Kosina
