Return-Path: <linux-kernel-owner+w=401wt.eu-S1758131AbZCNWbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131AbZCNWbZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 18:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbZCNWbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 18:31:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42055 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbZCNWbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 18:31:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>
Subject: Re: [RFC][PATCH][0/8] PM: Rework suspend-resume ordering to avoid problems with shared interrupts
Date: Sat, 14 Mar 2009 23:31:26 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8-tst; KDE/4.2.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       linux-pm@lists.linux-foundation.org
References: <200902221837.49396.rjw@sisk.pl> <200903141259.02164.rjw@sisk.pl> <200903141511.58455.elendil@planet.nl>
In-Reply-To: <200903141511.58455.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903142331.27304.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 March 2009, Frans Pop wrote:
> On Saturday 14 March 2009, you wrote:
> > Could you please also test the last iteration of the $subject patch
> > series (just sent) with the appended patch applied on top and post
> > dmesg output?
> 
> Here you are:
> - boot
> - STR with wireless networking
> - STD with wireless networking
> - STR with wired networking and killswitch on wireless
> 
> No problems seen :-)

Great, thanks for the log, it looks correct.

Best,
Rafael
