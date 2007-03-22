Return-Path: <linux-kernel-owner+w=401wt.eu-S1161115AbXCVVw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161115AbXCVVw0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 17:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161121AbXCVVw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 17:52:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36875 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161115AbXCVVwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 17:52:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sergey Smirnov <svs1957@gmail.com>
Subject: Re: HELP!!! SD and suspend damage i-node.
Date: Thu, 22 Mar 2007 22:55:19 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
References: <4602781C.9060804@gmail.com>
In-Reply-To: <4602781C.9060804@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703222255.20167.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 22 March 2007 13:35, Sergey Smirnov wrote:
> I use 2.6.20.2 kernel with ext3 rootfs on 4Gb SD on sharp zaurus sl-750 (PXA255).
> After suspend/resume filesystem stay clean. But some i-nodes become broken.
> Some files looks like block device or pipe with strange permissions, owner etc.
> I'm sure that there is no bad blocks on SD.
> I'll send any additional information. Just say me what you need to help me.
> I had i lot of tries. Apply patches, remove its, change fstype etc.
> output of fsck -f

I assume this is the suspend to RAM?

Rafael
