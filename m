Return-Path: <linux-kernel-owner+w=401wt.eu-S1754022AbYFBK3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbYFBK3A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 06:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757912AbYFBK2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 06:28:43 -0400
Received: from anchor-post-33.mail.demon.net ([194.217.242.91]:2534 "EHLO
	anchor-post-33.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757704AbYFBK2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 06:28:42 -0400
Message-ID: <4843CB52.70808@rsk.demon.co.uk>
Date: Mon, 02 Jun 2008 11:28:34 +0100
From: richard kennedy <richard@rsk.demon.co.uk>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: gregkh <gregkh@suse.de>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kobject: reorder kobject to save space on 64 bit builds
References: <1212401245.2966.8.camel@castor.localdomain>
In-Reply-To: <1212401245.2966.8.camel@castor.localdomain>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Kennedy wrote:
> reorder kobject to save space on 64 bit builds.
> shrinks from 76 to 64 bytes & moves allocated kobject to a smaller
> slab. 

That size change should be 72 -> 64!

Sorry
Richard

