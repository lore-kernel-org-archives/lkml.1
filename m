Return-Path: <linux-kernel-owner+w=401wt.eu-S1758273AbZADXLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273AbZADXLR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 18:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbZADXLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 18:11:03 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49678 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616AbZADXLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 18:11:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [Regression] X server doesn't start on MSI Wind w/ current mainline
Date: Mon, 5 Jan 2009 00:11:32 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@gmail.com>
References: <200901031328.40574.rjw@sisk.pl>
In-Reply-To: <200901031328.40574.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901050011.32974.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 January 2009, Rafael J. Wysocki wrote:
> Hi,
> 
> With the current mainline and the linux-next branch of your pci-2.6 tree on
> top, the X server doesn't start any more on MSI Wind (Intel hardware) w/
> openSUSE 11.1 .
> 
> I also tested the linux-next branch of the pci-2.6 tree on top of 2.6.28 and
> it doesn't cause any problem with the X server to happen.

Well, I pulled the mainline from today, unsetted DRM_I915_KMS and it works
again.

BTW, what user land is necessary for the KMS to work?

Thanks,
Rafael
