Return-Path: <linux-kernel-owner+w=401wt.eu-S1753719AbXKVQQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719AbXKVQQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 11:16:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbXKVQQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 11:16:19 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54375 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbXKVQQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 11:16:18 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Tvrtko A. Ursulin" <tvrtko.ursulin@sophos.com>
Subject: Re: [2.6.24-rc] pdflush stuck in D state
Date: Thu, 22 Nov 2007 17:34:01 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <200711220943.38929.tvrtko.ursulin@sophos.com>
In-Reply-To: <200711220943.38929.tvrtko.ursulin@sophos.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711221734.01953.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 22 of November 2007, Tvrtko A. Ursulin wrote:
> 
> Hi all,
> 
> So as the subject says - pdflush is stuck i D state which means constant load 
> average of at least one:
> 
> root       151  0.0  0.0      0     0 ?        D    Nov20   0:33 [pdflush]

Hm, this is supposed to be fixed.  Please see:
http://bugzilla.kernel.org/show_bug.cgi?id=9323

Thanks,
Rafael
