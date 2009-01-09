Return-Path: <linux-kernel-owner+w=401wt.eu-S1755517AbZAIK0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbZAIK0n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 05:26:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbZAIK0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 05:26:34 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:48925 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbZAIK0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 05:26:34 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Pavel Machek <pavel@suse.cz>
Subject: Re: [Regression] USB wakeup problem on Toshiba Portege R500
Date: Fri, 9 Jan 2009 11:26:55 +0100
User-Agent: KMail/1.9.10
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200901080835.39639.rjw@sisk.pl> <200901081748.58962.oliver@neukum.org> <20090109101840.GD3396@elf.ucw.cz>
In-Reply-To: <20090109101840.GD3396@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901091126.57094.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Friday 09 January 2009 11:18:41 schrieb Pavel Machek:
> laptops normally wake up lid open... (and you still have a
> powerbutton; plus I'm not aware of any laptops with usb keyboard --
> are apples crazy enough to do that?)

Yes, they are. Do they wake if you hit the power button or close and
reopen the lid? If so, I am satisfied and have no problem with reverting.

	Regards
		Oliver

