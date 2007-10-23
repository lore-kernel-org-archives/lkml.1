Return-Path: <linux-kernel-owner+w=401wt.eu-S1755159AbXJWS23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159AbXJWS23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 14:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbXJWS2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 14:28:22 -0400
Received: from twin.jikos.cz ([213.151.79.26]:56160 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbXJWS2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 14:28:21 -0400
Date: Tue, 23 Oct 2007 20:28:04 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Marcel Holtmann <marcel@holtmann.org>
cc: Alon Bar-Lev <alon.barlev@gmail.com>, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net
Subject: Re: [BUG] rfcomm]
In-Reply-To: <1193163905.6184.214.camel@violet>
Message-ID: <Pine.LNX.4.64.0710232026180.18815@twin.jikos.cz>
References: <200710231950.31313.alon.barlev@gmail.com>  <1193162106.6184.208.camel@violet>
  <Pine.LNX.4.64.0710232004260.18815@twin.jikos.cz> <1193163905.6184.214.camel@violet>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2007, Marcel Holtmann wrote:

> > actually uswsusp has been upstream for quite some time already. See 
> > Documentation/power/userland-swsusp.txt
> nice. I've never used it. Currently I am using what comes with Ubuntu
> 7.10 and that seems to work.

Never used ubuntu, so I have no idea what they ship, I guess you use 
s2ram/s2disk utilitie. If so, you are using uswsusp too.

-- 
Jiri Kosina
