Return-Path: <linux-kernel-owner+w=401wt.eu-S1754552AbXJWSHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbXJWSHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 14:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbXJWSHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 14:07:03 -0400
Received: from twin.jikos.cz ([213.151.79.26]:54670 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614AbXJWSHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 14:07:01 -0400
Date: Tue, 23 Oct 2007 20:06:27 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Marcel Holtmann <marcel@holtmann.org>
cc: Alon Bar-Lev <alon.barlev@gmail.com>, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net
Subject: Re: [BUG] rfcomm]
In-Reply-To: <1193162106.6184.208.camel@violet>
Message-ID: <Pine.LNX.4.64.0710232004260.18815@twin.jikos.cz>
References: <200710231950.31313.alon.barlev@gmail.com> <1193162106.6184.208.camel@violet>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2007, Marcel Holtmann wrote:

> Second, can you try without uswsusp or suspend2. Both of them are not 
> upstream and I can't tell how much these would effect this kind of 
> behavior.

Hi Marcel,

actually uswsusp has been upstream for quite some time already. See 
Documentation/power/userland-swsusp.txt

Thanks,

-- 
Jiri Kosina
