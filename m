Return-Path: <linux-kernel-owner+w=401wt.eu-S1753823AbZK1Jdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbZK1Jdu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 04:33:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753735AbZK1Jdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 04:33:49 -0500
Received: from [195.7.61.12] ([195.7.61.12]:34296 "EHLO killala.koala.ie"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753190AbZK1Jds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 04:33:48 -0500
X-Greylist: delayed 1764 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Nov 2009 04:33:48 EST
Message-ID: <4B10E79B.2050609@koala.ie>
Date: Sat, 28 Nov 2009 09:04:27 +0000
From: Simon Kenyon <simon@koala.ie>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
References: <BDgcsm11qgB@lirc>
In-Reply-To: <BDgcsm11qgB@lirc>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Bartelmus wrote:
 > A user friendly GUI tool to configure the mapping of the remote 
buttons is
 > essential for good user experience. I hope noone here considers that 
users
 > learn command line or bash to configure their remotes.

oh please no
the major, major problem with bluetooth is that there is *only* a gui
the core system should use the command line and then a gui (or guis) can 
follow

 > Nobody is manually writing lircd.conf files. Of course you don't want 
the
 > user to know anything about the technical details unless you really 
want
 > to get your hands dirty.

speak for yourself

 > If it ain't broke, don't fix it.

i have been hacking lirc for *so many years* because i needed two 
separate serial inputs. so that is most assuredly broken
