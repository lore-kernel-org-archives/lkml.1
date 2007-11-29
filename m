Return-Path: <linux-kernel-owner+w=401wt.eu-S933750AbXK2V4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933750AbXK2V4A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 16:56:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762810AbXK2Vzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 16:55:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56174 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932885AbXK2Vzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 16:55:36 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tino Keitel <tino.keitel@gmx.de>, David Chinner <dgc@sgi.com>
Subject: Re: XFS related Oops (suspend/resume related)
Date: Thu, 29 Nov 2007 23:13:52 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <20071112064706.GA23595@dose.home.local> <200711292205.25431.rjw@sisk.pl> <20071129204943.GA1960@dose.home.local>
In-Reply-To: <20071129204943.GA1960@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711292313.53409.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 29 of November 2007, Tino Keitel wrote:
> On Thu, Nov 29, 2007 at 22:05:24 +0100, Rafael J. Wysocki wrote:
> 
> [...]
> 
> > Tino, can you check if this patch helps, please?
> 
> Not really. I suspend one to several times a day, and in most cases
> resume works. I thing checking the patch is hard when I have no real
> procedure to reproduce the resume failure.

I see.

Still, I think that the patch is needed.

David, are you going to take it or do you want me to push it upstream?

Rafael
