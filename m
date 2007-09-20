Return-Path: <linux-kernel-owner+w=401wt.eu-S1752728AbXITUNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbXITUNN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 16:13:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751097AbXITUM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 16:12:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39993 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbXITUM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 16:12:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
Subject: Re: what is the difference between shutdown command and writing to /sys/power/state
Date: Thu, 20 Sep 2007 22:25:41 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <A3258B497F1C1441AD36A2E8B45FD628ACF018@scsmsx412.amr.corp.intel.com> <200709200209.11331.rjw@sisk.pl> <A3258B497F1C1441AD36A2E8B45FD628ACF82B@scsmsx412.amr.corp.intel.com>
In-Reply-To: <A3258B497F1C1441AD36A2E8B45FD628ACF82B@scsmsx412.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709202225.41429.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 20 September 2007 20:11, Agarwal, Lomesh wrote:
> Can someone tell me the flow of code for these two scenarios -
> I write disk to /sys/power/state. How does system go to hibernation? How
> does this trigger ACPI driver functions?
> I issue shutdown command.
> I am using 2.6.18 kernel.

It's quite old for current standards. :-)

I'll need to get the source and look into it to be able to answer, so please
give me some time.

BTW, please don't top post.

Greetings,
Rafael
