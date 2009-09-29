Return-Path: <linux-kernel-owner+w=401wt.eu-S1753645AbZI2RbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645AbZI2RbB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 13:31:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753448AbZI2RbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 13:31:00 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:62484 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbZI2Ra7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 13:30:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=ScnhAHWBi/GWHwt2tUzfhrBCL7e/4emFJtlKLBoGSuDiU/7hLs8HqVYlQ5ZM7WlP3k
         KHzeGZ4vPQiaG8z+I+5dWF5HRwHwiDmnMd0BzCDtjDHCMRCQR+l39FK/VKrfLeY8UME1
         PRgbvb5hhjEYRA+pt5rqwHNTIRJDVTAz3z8UI=
From: Volker Armin Hemmann <volkerarmin@googlemail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: 2.6.31 ehci problem - mouse dead on scroll
Date: Tue, 29 Sep 2009 19:30:56 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31.1r4; KDE/4.3.1; x86_64; ; )
Cc: Oliver Neukum <oliver@neukum.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
References: <Pine.LNX.4.44L0.0909211641580.4414-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0909211641580.4414-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200909291930.57037.volkerarmin@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Montag 21 September 2009, Alan Stern wrote:

> 
> It is.  The usbmon log shows some unexpected gaps, which probably
> correspond to the jerkiness.  But there's nothing to indicate that
> these gaps are the computer's fault.
> 
> Have you tried using a different mouse, or a different brand of mouse,
> on this computer?  Or using your mouse on a different machine?


sorry for the long break. I got a different mouse and tried it for a couple of 
hours and haven't got the jerkiness so far. 
But:
the other mouse has a lot worse resolution. Which results in a 'slower' mouse.
my own mouse has stretches of hours were it is ok.

So... it might take some more time to trigger it. I will then report back

Glück Auf,
Volker
