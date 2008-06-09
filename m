Return-Path: <linux-kernel-owner+w=401wt.eu-S1762892AbYFIWoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762892AbYFIWoP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 18:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762687AbYFIWkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 18:40:18 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:58309 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761663AbYFIWkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 18:40:15 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: "Justin Mattock" <justinmattock@gmail.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jiri Kosina <jkosina@suse.cz>, Greg KH <greg@kroah.com>
Subject: Re: [Bug #10825] appletouch after wakeup
Date: Tue, 10 Jun 2008 00:40:33 +0200
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <GIilET9wkhI.A.JzB.81vSIB@albercik> <dd18b0c30806091504u43e0e901jb786e57f5cbf47cd@mail.gmail.com> <dd18b0c30806091536s724ba33cmfdd9ccb49b0cbd53@mail.gmail.com>
In-Reply-To: <dd18b0c30806091536s724ba33cmfdd9ccb49b0cbd53@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806100040.34377.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 10 Juni 2008 00:36:02 schrieb Justin Mattock:

> O.K. This is smaller than last weeks? anyways I applied the patch, and

That patch also saved some power, this just fixes bugs. It's indeed smaller.

> am not seeing appletouch freak out like it did, also
> two finger scroll is still active upon wakeup(FWIW).  Cool, and thanks

Dmitry, Greg,

we have confirmation. Would you take the patch for 2.6.26 and stable?

	Regards
		Oliver
