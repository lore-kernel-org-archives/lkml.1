Return-Path: <linux-kernel-owner+w=401wt.eu-S1755760AbYIYUvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760AbYIYUvy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 16:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbYIYUvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 16:51:45 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:24127 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbYIYUvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 16:51:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=BOSIvBW7BCiTfDAkCzMfxOPCxmPohCP86EplC+TzmIuyg/BrCPJkT7IIHWkgycGimS
         SyCUAUZIegV5aOTQik2WFm5yLY7d/U8pIqJ6q6f42vG5k9dQhnm0OM9tqROh0dmeJg5p
         DsIS4feTiEO5Okvn0pVN11/VTEa67gKFAoxPo=
Message-ID: <48DBF9C5.3030001@gmail.com>
Date: Thu, 25 Sep 2008 22:51:17 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: suspend (uhci_hcd) defunct in mmotm 2008-09-13-03-09
References: <Pine.LNX.4.44L0.0809241722010.2181-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0809241722010.2181-100000@iolanthe.rowland.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern napsal(a):
> If everyone is okay with it, I'll submit the patch with a proper 
> Changelog and Signed-off-by.

Confirming, it works now!
