Return-Path: <linux-kernel-owner+w=401wt.eu-S1758670AbXISX4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758670AbXISX4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 19:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753494AbXISX40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 19:56:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36218 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752915AbXISX4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 19:56:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
Subject: Re: what is the difference between shutdown command and writing to /sys/power/state
Date: Thu, 20 Sep 2007 02:09:11 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <A3258B497F1C1441AD36A2E8B45FD628ACF018@scsmsx412.amr.corp.intel.com> <200709192334.30944.rjw@sisk.pl> <A3258B497F1C1441AD36A2E8B45FD628ACF21D@scsmsx412.amr.corp.intel.com>
In-Reply-To: <A3258B497F1C1441AD36A2E8B45FD628ACF21D@scsmsx412.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709200209.11331.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 19 September 2007 23:37, Agarwal, Lomesh wrote:
> Can you tell me the differences?
> Also what do you mean by - depending also on what you mean by 'now'? I

Please tell me what kernel version you're referring to.

> gave now as a time parameter to shutdown command. How can it be
> interpreted in a different way?

Sorry, I have misunderstood your post (the "now" doesn't look as a part of the
command).

Greetings,
Rafael


> -----Original Message-----
> From: Rafael J. Wysocki [mailto:rjw@sisk.pl] 
> Sent: Wednesday, September 19, 2007 2:35 PM
> To: Agarwal, Lomesh
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: what is the difference between shutdown command and writing
> to /sys/power/state
> 
> On Wednesday, 19 September 2007 20:50, Agarwal, Lomesh wrote:
> > Does linux handles writing "disk" to /sys/power/state and shutdown -P
> > now differently (except writing to disk part)?
> 
> Yes, it does (depending also on what you mean by 'now').
