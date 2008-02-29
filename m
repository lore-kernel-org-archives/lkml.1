Return-Path: <linux-kernel-owner+w=401wt.eu-S1759793AbYB2La5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759793AbYB2La5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 06:30:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbYB2Las
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 06:30:48 -0500
Received: from ozlabs.org ([203.10.76.45]:52881 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182AbYB2Lar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 06:30:47 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18375.60394.166769.540668@cargo.ozlabs.ibm.com>
Date: Fri, 29 Feb 2008 22:26:34 +1100
From: Paul Mackerras <paulus@samba.org>
To: Jarod Wilson <jwilson@redhat.com>
Cc: benh@kernel.crashing.org, Kristian Hoegsberg <krh@bitplanet.net>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Stefan Richter <stefanr@s5r6.in-berlin.de>, sparclinux@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net, Sam Ravnborg <sam@ravnborg.org>,
       Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH 1/2] firewire: endianess fix
In-Reply-To: <47C79CB1.6050104@redhat.com>
References: <20080220220326.GA22328@uranus.ravnborg.org>
	<200802272221.38985.jwilson@redhat.com>
	<1204179959.15052.372.camel@pasglop>
	<200802281342.06493.jwilson@redhat.com>
	<1204241162.15052.393.camel@pasglop>
	<47C79CB1.6050104@redhat.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarod Wilson writes:

> Still no luck finding one here. The person I was thinking of has a 
> Lombard, which has no firewire. I did get ahold of a 667MHz Titanium, 
> but its got an Agere FW323. Pretty sure my old man actually has a Pismo, 
> but its about a 3000 mile drive over to my folks house. The search 
> continues... I wonder how many people still actually 1) have a machine 
> with this controller, 2) are running Linux on it and 3) use firewire 
> devices with it. Both of you, please speak up, we're trying to help you! 
> (if only out of morbid curiosity to see this mythical goofy controller).

I have a first-generation titanium powerbook that has this controller
(assuming we're talking about vendor/device id = 0x106b / 0x18), and
yes I run Linux (only) on it and use firewire disks. :)

Paul.
