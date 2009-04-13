Return-Path: <linux-kernel-owner+w=401wt.eu-S1753968AbZDMS2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbZDMS2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 14:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753747AbZDMS2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 14:28:19 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:63177 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584AbZDMS2S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 14:28:18 -0400
MIME-Version: 1.0
In-Reply-To: <20090408210013.62e878c6@halo.dirtyepic.sk.ca>
References: <49C03208.6050603@gmail.com>
	 <1237399938.4529.208.camel@localhost.localdomain>
	 <49C572CC.6090704@gmail.com>
	 <20090323190720.GA16831@linux-os.sc.intel.com>
	 <49C95C66.2050100@gmail.com> <20090324222516.GA4292@elte.hu>
	 <20090408210013.62e878c6@halo.dirtyepic.sk.ca>
Date: Mon, 13 Apr 2009 13:27:52 -0500
Message-ID: <be01dd250904131127r15629e74t550a5a1dc5f72aa8@mail.gmail.com>
Subject: Re: Error: freeing invalid memtype
From: "Jason D. Clinton" <me@jasonclinton.com>
To: Ryan Hill <dirtyepic@gentoo.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 8, 2009 at 10:00 PM, Ryan Hill <dirtyepic@gentoo.org> wrote:
> I'm running 2.6.29.1 which has this patch but I'm still seeing an insane
> number of these.  I can't trigger them just by running glxinfo like
> Kevin, however opening a few tabs containing large images in firefox does the
> trick and also freezes my system for about a minute.
...
> wxwidgets @ gentoo     EFFD 380E 047A 4B51 D2BD C64F 8AA8 8346 F9A4 0662

(replying from off-list)
100% "me too" but in Fedora rawhide--so it does not appear to be a
distro-specific patch. Exact same reproduction criteria.
