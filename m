Return-Path: <linux-kernel-owner+w=401wt.eu-S1753911AbXCTVtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbXCTVtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 17:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753913AbXCTVtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 17:49:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55140 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753911AbXCTVtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 17:49:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: x60 time travels after resume
Date: Tue, 20 Mar 2007 22:52:34 +0100
User-Agent: KMail/1.9.5
Cc: kernel list <linux-kernel@vger.kernel.org>
References: <20070320123232.GA18994@elf.ucw.cz>
In-Reply-To: <20070320123232.GA18994@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703202252.34379.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 20 March 2007 13:32, Pavel Machek wrote:
> Hi!
> 
> ..and machine is pretty unhappy about that. I triggered it by
> paralel-building kernel while suspending/resuming.
> 
> root@amd:/home/pavel/sf/suspend# date
> Thu Feb 12 05:22:32 CET 1914
> root@amd:/home/pavel/sf/suspend#
> 
> ...and no, it is not easily reproducible :-(.

Can I see the .config please?

Rafael
