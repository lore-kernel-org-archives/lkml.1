Return-Path: <linux-kernel-owner+w=401wt.eu-S1753406AbZGQUTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbZGQUTe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 16:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbZGQUTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 16:19:33 -0400
Received: from kroah.org ([198.145.64.141]:43044 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126AbZGQUTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 16:19:32 -0400
Date: Fri, 17 Jul 2009 13:16:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 00/24] 2.6.30.2-stable review
Message-ID: <20090717201639.GA14209@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the start of the stable review cycle for the 2.6.30.2 release.

NOTE!  I still have a number of patches that people have submitted for
the .30 -stable tree, yet they do not show up in this release.  That is
due to the fact that I want to get this release out as soon as possible
due to some public security issues that are addressed here, and the fact
that I'm supposed to go on vacation in a few hours :)

Please know that the patches you have submitted, will show up in the
next .30-stable release after this one, they have not been forgotten,
and are not lost.  Thanks for your patience.

There are 24 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the
Cc: line.  If you wish to be a reviewer, please email stable@kernel.org
to add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Sunday July 19, 20:00:00 UTC UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.30.2-rc1.gz
and the diffstat can be found below.


thanks,

greg "I need to go pack the car now" k-h
