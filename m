Return-Path: <linux-kernel-owner+w=401wt.eu-S1754193AbYIIErl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbYIIErl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 00:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbYIIErb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 00:47:31 -0400
Received: from parsec.stupidest.org ([71.6.196.126]:54174 "EHLO
	parsec.stupidest.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbYIIErb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 00:47:31 -0400
X-Greylist: delayed 680 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Sep 2008 00:47:31 EDT
Date: Mon, 8 Sep 2008 21:36:10 -0700
From: Chris Wedgwood <cw@f00f.org>
To: Jarod Wilson <jwilson@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
       Janne Grunau <j@jannau.net>, Christoph Bartelmus <lirc@bartelmus.de>,
       Eric Sandeen <esandeen@redhat.com>,
       Mario Limonciello <superm1@ubuntu.com>
Subject: Re: [PATCH 0/18] linux infrared remote control drivers
Message-ID: <20080909043610.GA2251@puku.stupidest.org>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220933164-10160-1-git-send-email-jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2008 at 12:05:45AM -0400, Jarod Wilson wrote:

> The following patch series adds 17 new drivers for assorted infrared
> and/or RF remote control receivers and/or transmitters.

Why does most of this have to be in the kernel?  Can a lot of this not
be done from userspace?
