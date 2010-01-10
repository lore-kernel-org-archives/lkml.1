Return-Path: <linux-kernel-owner+w=401wt.eu-S1753892Ab0AJVEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab0AJVEY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 16:04:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753754Ab0AJVEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 16:04:12 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57533 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753797Ab0AJVEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 16:04:10 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Subject: Re: i915 drm fails to resume with modeset = 0
Date: Sun, 10 Jan 2010 22:04:29 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, airlied@redhat.com,
       ajax@redhat.com, luto@mit.edu
References: <c4e36d111001040827v850c94ev7166ac02f52e9a38@mail.gmail.com>
In-Reply-To: <c4e36d111001040827v850c94ev7166ac02f52e9a38@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001102204.29624.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 January 2010, Zdenek Kabelac wrote:
> Hi
> 
> Resume seems to fail when i915 modeset is 0.  Machine produces following oops:

This looks like http://bugzilla.kernel.org/show_bug.cgi?id=15026

Rafael
