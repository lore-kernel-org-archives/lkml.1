Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbZBEHmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbZBEHmh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 02:42:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753314AbZBEHm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 02:42:29 -0500
Received: from mail.openmoko.org ([88.198.124.205]:34107 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbZBEHm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 02:42:28 -0500
Date: Thu, 5 Feb 2009 13:12:03 +0530
From: Balaji Rao <balajirrao@openmoko.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andy Green <andy@openmoko.com>, Samuel Ortiz <sameo@openedhand.com>,
       linux-kernel@vger.kernel.org
Subject: Re: mfd/pcf50633-gpio.c is completely unused
Message-ID: <20090205074202.GB3159@fedora.yogi>
References: <20090204194844.GA26138@localhost.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090204194844.GA26138@localhost.pp.htv.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 04, 2009 at 09:48:51PM +0200, Adrian Bunk wrote:
> I'm wondering:
> 
> Is any user for the code in drivers/mfd/pcf50633-gpio.c pending, or did 
> something go wrong when merging it?
> 
> Currently it is completely unused.
> 

Hi Adrian,

Yes, there are no users on mainline yet.

Regards,
Balaji

