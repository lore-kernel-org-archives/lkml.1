Return-Path: <linux-kernel-owner+w=401wt.eu-S1761561AbYB1Soc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761561AbYB1Soc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 13:44:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761309AbYB1SoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 13:44:18 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760541AbYB1SoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 13:44:16 -0500
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: benh@kernel.crashing.org
Subject: Re: [PATCH 1/2] firewire: endianess fix
Date: Thu, 28 Feb 2008 13:42:05 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Kristian Hoegsberg <krh@bitplanet.net>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net, Sam Ravnborg <sam@ravnborg.org>,
       Harvey Harrison <harvey.harrison@gmail.com>
References: <20080220220326.GA22328@uranus.ravnborg.org> <200802272221.38985.jwilson@redhat.com> <1204179959.15052.372.camel@pasglop>
In-Reply-To: <1204179959.15052.372.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802281342.06493.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 February 2008 01:25:59 am Benjamin Herrenschmidt wrote:
> > Under Mac OS X, system.log says "FireWire (OHCI) Apple ID 31 built-in now
> > active". Could still be lucent though, judging by the subsys device ID of
> > 5811, which matches up w/the Lucent/Agere FW323. But no, apparently I
> > don't have the interesting one.
>
> Well, it's interesting in the sense that it's a "normal" OHCI then on a
> BE machine :-) My Pismo, which had the weirdo one, unfortunately died a
> while ago. I'll see if I can find another machine with that one in.

Ah, the pismo has it, eh? I think I may actually know of someone in the office 
that still has one of those that I might be able to borrow and poke at...


-- 
Jarod Wilson
jwilson@redhat.com
