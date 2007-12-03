Return-Path: <linux-kernel-owner+w=401wt.eu-S1752628AbXLCVgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbXLCVgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 16:36:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbXLCVf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 16:35:58 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43448 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996AbXLCVf5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 16:35:57 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toralf =?iso-8859-15?q?F=F6rster?= <toralf.foerster@gmx.de>
Subject: Re: hibernation issue with kernel 2.6.23-gentoo-r3 at T41
Date: Mon, 3 Dec 2007 22:54:23 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Daniel Drake <dsd@gentoo.org>, linux-kernel@vger.kernel.org
References: <200712031419.41596.toralf.foerster@gmx.de> <47540950.4090207@gentoo.org> <200712031821.41550.toralf.foerster@gmx.de>
In-Reply-To: <200712031821.41550.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712032254.23656.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 3 of December 2007, Toralf Förster wrote:
> Hhm,
> 
> in general it seems to be a regression of kernel 2.6.23 with suspend/hibernate
> if a user mode linux image is runnning.
> 
> With previous kernel versions (tested gentoo-sources-2.6.22-r9 and 
> gentoo-sources-2.6.21-r4) I've no problem to either suspend or to hibernate the
> ThinkPad T41.
> 
> However with gentoo-sources-2.6.23-r3 the system didn't neither
> suspend nor hibernate. The good news is that the system doesn't hang :-)
 
Please file a bug report at
http://bugzilla.kernel.org/enter_bug.cgi?product=Power%20Management
against Hibernation/Suspend and add my address to the report's CC list.

Thanks,
Rafael
