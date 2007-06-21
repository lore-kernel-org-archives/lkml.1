Return-Path: <linux-kernel-owner+w=401wt.eu-S1760356AbXFUSEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760356AbXFUSEh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 14:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758837AbXFUSEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 14:04:30 -0400
Received: from warlock.qualcomm.com ([129.46.50.49]:62211 "EHLO
	warlock.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758440AbXFUSE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 14:04:29 -0400
X-Greylist: delayed 1864 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Jun 2007 14:04:29 EDT
Message-ID: <467AB4D5.9000801@qualcomm.com>
Date: Thu, 21 Jun 2007 10:26:45 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>
CC: Guido Guenther <agx@sigxcpu.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Allow group ownership of TUN/TAP devices
References: <20070618160549.GA8299@c2.user-mode-linux.org>
In-Reply-To: <20070618160549.GA8299@c2.user-mode-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Dike wrote:
> I recieved from Guido Guenther the patch below to the TUN/TAP driver
> which allows group ownerships to be effective.
> 
> It seems reasonable to me.

Looks good to me too. We'll add to my tree. In the mean time I don't
mind if one of net drv maintainers pushes it upstream.

Thanx
Max
