Return-Path: <linux-kernel-owner+w=401wt.eu-S936578AbXLRAJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936578AbXLRAJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 19:09:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933202AbXLRAJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 19:09:50 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55692 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933074AbXLRAJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 19:09:49 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tino Keitel <tino.keitel@gmx.de>
Subject: Re: Could not set non-blocking flag with 2.6.24-rc5
Date: Tue, 18 Dec 2007 01:28:46 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <20071213201601.GA5831@dose.home.local>
In-Reply-To: <20071213201601.GA5831@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712180128.46688.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 13 of December 2007, Tino Keitel wrote:
> Hi folks,
> 
> I often build Debian packages inside a chroot. Today I discovered a
> failure during an "aptitude update", which is a command to download new
> package lists for the package management. In strace, the lines around
> the failure look like this:

Can you please have a look at http://bugzilla.kernel.org/show_bug.cgi?id=9557
and provide the information requested in there?

Thanks,
Rafael
