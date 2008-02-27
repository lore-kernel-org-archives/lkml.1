Return-Path: <linux-kernel-owner+w=401wt.eu-S1760334AbYB0WVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760334AbYB0WVA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 17:21:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758298AbYB0WUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 17:20:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46790 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753905AbYB0WUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 17:20:51 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Klaus S. Madsen" <ksm@hjernemadsen.org>
Subject: Re: Regression in 2.6.25-rc3: s2ram segfaults before suspending
Date: Wed, 27 Feb 2008 23:19:11 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Machek <pavel@ucw.cz>
References: <20080227221033.GR17932@hjernemadsen.org>
In-Reply-To: <20080227221033.GR17932@hjernemadsen.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802272319.12246.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 27 of February 2008, Klaus S. Madsen wrote:
> Hi all,
> 
> 	I have a Thinkpad T61p, which I'm able to suspend with s2ram on
> Linux 2.6.24.3. However when I try to suspend it on 2.6.25-rc3, s2ram
> dies after changing to vt1, with a segfault. I'm using s2ram from cvs,
> and libx86 version 0.99 from http://www.codon.org.uk/~mjg59/libx86/.

There's a known suspend problem with 2.6.25-rc3 that has been fixed already
in the Linus' tree.  Can you test the current head of the Linus' tree, please?

Rafael
