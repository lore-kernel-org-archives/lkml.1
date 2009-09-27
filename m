Return-Path: <linux-kernel-owner+w=401wt.eu-S1753159AbZI0PMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159AbZI0PMr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 11:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbZI0PMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 11:12:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60203 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967AbZI0PMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 11:12:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Martin Wache <m.wache@gmx.net>
Subject: Re: Status of Regression/Bug 13407 adb trackpad disappears after suspend to ram?
Date: Sun, 27 Sep 2009 17:13:44 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <4ABF5432.9020508@gmx.net>
In-Reply-To: <4ABF5432.9020508@gmx.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200909271713.44719.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 September 2009, Martin Wache wrote:
> Hi all,
> 
> I'd like to ask if there is any news on the bug 13407
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=13407
> 
> The status of the bugreport is "NEEDINFO", I'm also hit by this bug, 
> using 2.6.31 on an iBook G4. Can I help in anyway to get this bug fixed? 
> I'm happy to provide any info I can, if there is need for more info. I 
> would also try patches if that helps.

A patch has been submitted which is reported to fix the issue:

http://patchwork.kernel.org/patch/49462/

Please test it as requested.

Best,
Rafael
