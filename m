Return-Path: <linux-kernel-owner+w=401wt.eu-S1757889AbXLJVLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889AbXLJVLZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 16:11:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbXLJVLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 16:11:18 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47907 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054AbXLJVLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 16:11:17 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Norbert Preining <preining@logic.at>
Subject: Re: kernel BUG: Eeek! page_mapcount(page) went negative!
Date: Mon, 10 Dec 2007 22:30:03 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <20071210104859.GI7003@gamma.logic.tuwien.ac.at> <20071210112135.GA19783@gamma.logic.tuwien.ac.at>
In-Reply-To: <20071210112135.GA19783@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712102230.04342.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 10 of December 2007, Norbert Preining wrote:
> On Mo, 10 Dez 2007, preining wrote:
> > I was running a kvm installing windows, and eek it crashed happily my
> > computer, probably because I forgot to give kvm -no-acpi option.
> 
> I forgot:
> 
> kernel 2.6.24-rc4
> kvm  55 (debian sid 55+dfsg-1)

Is this a regression?  If so, which kernel is last known good?

Thanks,
Rafael
