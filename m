Return-Path: <linux-kernel-owner+w=401wt.eu-S1753185AbYHIV5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbYHIV5w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 17:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbYHIV5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 17:57:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47019 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288AbYHIV5l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 17:57:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bruno =?iso-8859-15?q?Pr=E9mont?= <bonbons@linux-vserver.org>
Subject: Re: [2.6.27-rc2-git4] Kernel panic on VIA Ester+VIA CX700
Date: Sun, 10 Aug 2008 00:00:24 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org
References: <20080809225153.2fdb23a8@neptune.home>
In-Reply-To: <20080809225153.2fdb23a8@neptune.home>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808100000.25402.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 9 of August 2008, Bruno Prémont wrote:
> Hi,

Hi,

> Trying out 2.6.27-rc2-git4 on a VIA Ester + CX700 based system I
> experience the following panic using a config obtained with make
> oldconfig from working 2.6.26 config.
> 
> Looking at the traces and when it happens it looks like it could be
> libATA or SCSI related...
> 
> 
> Note: the kernel is patched with viafb patches sent yesterday ([y]) and
> squashfs (<m>)

Could you retest without these two, please?

Thanks,
Rafael
