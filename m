Return-Path: <linux-kernel-owner+w=401wt.eu-S1755046AbXKSVq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbXKSVq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 16:46:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbXKSVqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 16:46:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40075 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495AbXKSVqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 16:46:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.24-rc3: find complains about /proc/net
Date: Mon, 19 Nov 2007 23:04:24 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: kernel list <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
References: <20071119191000.GA1560@elf.ucw.cz>
In-Reply-To: <20071119191000.GA1560@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711192304.25087.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 19 of November 2007, Pavel Machek wrote:
> Hi!
> 
> I think that this worked before:
> 
> root@amd:/proc# find . -name "timer_info"
> find: WARNING: Hard link count is wrong for ./net: this may be a bug
> in your filesystem driver.  Automatically turning on find's -noleaf
> option.  Earlier results may have failed to include directories that
> should have been searched.
> root@amd:/proc#

I'm seeing that too.

Rafael
