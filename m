Return-Path: <linux-kernel-owner+w=401wt.eu-S1761125AbYFJAGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761125AbYFJAGs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 20:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbYFJAGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 20:06:40 -0400
Received: from styx.suse.cz ([82.119.242.94]:37067 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751442AbYFJAGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 20:06:39 -0400
Date: Tue, 10 Jun 2008 02:06:38 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Justin Mattock <justinmattock@gmail.com>
cc: Oliver Neukum <oliver@neukum.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Greg KH <greg@kroah.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bug #10825] appletouch after wakeup
In-Reply-To: <dd18b0c30806091703s1e21d204m3991f6c51b578450@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0806100205340.10085@jikos.suse.cz>
References: <GIilET9wkhI.A.JzB.81vSIB@albercik> 
 <dd18b0c30806091504u43e0e901jb786e57f5cbf47cd@mail.gmail.com> 
 <dd18b0c30806091536s724ba33cmfdd9ccb49b0cbd53@mail.gmail.com> 
 <200806100040.34377.oliver@neukum.org> <dd18b0c30806091703s1e21d204m3991f6c51b578450@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2008, Justin Mattock wrote:

> Please ignore the two finger scroll part(even though it seems to work), 
> I have been ignoring my xorg.conf for sometime and need to configure it 
> so I can have all functionality back, and then I'll let you know what 
> the status is. regards;

You can easily test with 'evtest' utility to see the data that are really 
comming out of a kernel for your particular device, to filter out any 
mangling that X does on these events.

-- 
Jiri Kosina
SUSE Labs
