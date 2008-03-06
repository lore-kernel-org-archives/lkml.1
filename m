Return-Path: <linux-kernel-owner+w=401wt.eu-S1764380AbYCFMJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764380AbYCFMJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 07:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933327AbYCFMId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 07:08:33 -0500
Received: from styx.suse.cz ([82.119.242.94]:45795 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760550AbYCFMIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 07:08:31 -0500
Date: Thu, 6 Mar 2008 13:08:30 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Pekka Sarnila <sarnila@adit.fi>
cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] hid: quirk to fixup fullspeed interval on highspeed
 devices
In-Reply-To: <47CC0D5E.6040405@adit.fi>
Message-ID: <Pine.LNX.4.64.0803061307350.15209@jikos.suse.cz>
References: <47C96DEB.5070304@adit.fi> <Pine.LNX.4.64.0803031333080.15209@jikos.suse.cz>
 <47CC0D5E.6040405@adit.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2008, Pekka Sarnila wrote:

> Anyway, in the case of this particular device it was justified to limit 
> the quirk to HID-class. What to do in general is the question: My guess 
> is (without interface or endpoint specific quirks) class specific quirks 
> hit the target more precisely. But it is really only a guess.

OK, I agree, thanks. I will apply your patch to my tree.

-- 
Jiri Kosina
SUSE Labs
