Return-Path: <linux-kernel-owner+w=401wt.eu-S1754817AbZLCQpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbZLCQpR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 11:45:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754070AbZLCQpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 11:45:16 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:44951 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbZLCQpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 11:45:16 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: root hub lost power or was reset
Date: Thu, 3 Dec 2009 17:45:26 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
       Robert Hancock <hancockrwd@gmail.com>,
       "Linux-usb" <linux-usb@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0912031014190.4795-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0912031014190.4795-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912031745.26389.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 3. Dezember 2009 16:16:58 schrieb Alan Stern:
> And it seems to be very widespread.  I haven't seen more than a handful 
> of systems which _don't_ cut power or reset their UHCI controllers 
> during S3 sleep.

Yes, nevertheless it is most annoying. I wonder whether we could
get BIOS writers to export this feature via ACPI.

	Regards
		Oliver
