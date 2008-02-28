Return-Path: <linux-kernel-owner+w=401wt.eu-S1756087AbYB1G1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087AbYB1G1b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 01:27:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751582AbYB1G1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 01:27:22 -0500
Received: from gate.crashing.org ([63.228.1.57]:37181 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbYB1G1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 01:27:21 -0500
Subject: Re: [PATCH 1/2] firewire: endianess fix
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Jarod Wilson <jwilson@redhat.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Kristian Hoegsberg <krh@bitplanet.net>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net, Sam Ravnborg <sam@ravnborg.org>,
       Harvey Harrison <harvey.harrison@gmail.com>
In-Reply-To: <200802272221.38985.jwilson@redhat.com>
References: <20080220220326.GA22328@uranus.ravnborg.org>
	 <200802271458.28401.jwilson@redhat.com>
	 <1204166422.15052.334.camel@pasglop>
	 <200802272221.38985.jwilson@redhat.com>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 17:25:59 +1100
Message-Id: <1204179959.15052.372.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Under Mac OS X, system.log says "FireWire (OHCI) Apple ID 31 built-in now 
> active". Could still be lucent though, judging by the subsys device ID of 
> 5811, which matches up w/the Lucent/Agere FW323. But no, apparently I don't 
> have the interesting one.

Well, it's interesting in the sense that it's a "normal" OHCI then on a
BE machine :-) My Pismo, which had the weirdo one, unfortunately died a
while ago. I'll see if I can find another machine with that one in.

Cheers,
Ben.


