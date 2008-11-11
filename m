Return-Path: <linux-kernel-owner+w=401wt.eu-S1754589AbYKKRgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbYKKRgd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 12:36:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbYKKRgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 12:36:25 -0500
Received: from styx.suse.cz ([82.119.242.94]:32934 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752246AbYKKRgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 12:36:24 -0500
Date: Tue, 11 Nov 2008 18:36:23 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid: Complete support for the new unibody macbooks
In-Reply-To: <49109C91.6090207@euromail.se>
Message-ID: <alpine.LNX.1.10.0811111835540.24889@jikos.suse.cz>
References: <49109C91.6090207@euromail.se>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Nov 2008, Henrik Rydberg wrote:

> The unibody MacBook 5 and MacBook Pro 5 come with a new version of
> the bcm5974 trackpad. This patch adds the USB device ids and all
> the appropriate quirks, including hid_blacklist.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>

Applied, thanks Henrik (and sorry for the delay, I have been offline for a 
few days).

-- 
Jiri Kosina
SUSE Labs
