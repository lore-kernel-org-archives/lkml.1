Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836AbYIYMXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbYIYMXh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 08:23:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753029AbYIYMXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 08:23:25 -0400
Received: from styx.suse.cz ([82.119.242.94]:38325 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752999AbYIYMXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 08:23:24 -0400
Date: Thu, 25 Sep 2008 14:24:29 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Dave Airlie <airlied@gmail.com>
cc: David Miller <davem@davemloft.net>, david.vrabel@csr.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       chrisl@vmware.com
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
In-Reply-To: <21d7e9970809231409r3fdd640h53a72a808266d220@mail.gmail.com>
Message-ID: <alpine.LNX.1.10.0809251423290.4671@pegasus.suse.cz>
References: <21d7e9970809221826i76081719pdd749237580fc68e@mail.gmail.com>  <20080922.185902.80812984.davem@davemloft.net>  <alpine.LNX.1.10.0809231229460.4671@pegasus.suse.cz>  <20080923.140519.268233735.davem@davemloft.net>
 <21d7e9970809231409r3fdd640h53a72a808266d220@mail.gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2008, Dave Airlie wrote:

> > My current suspicion in all of this is either the GEM kernel patches
> > or recent X server.
> I don't think OpenSUSE was shipping any of the GEM bits.

Actually there is no way of not shipping GEM when shipping xorg 7.4, isn't 
it?

So definitely GEM could be potential cause here, I think.

-- 
Jiri Kosina
SUSE Labs
