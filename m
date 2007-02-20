Return-Path: <linux-kernel-owner+w=401wt.eu-S965646AbXBTDnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965646AbXBTDnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 22:43:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965648AbXBTDnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 22:43:47 -0500
Received: from nz-out-0506.google.com ([64.233.162.231]:54773 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965631AbXBTDnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 22:43:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=iskg6XBtk0ESQIM4x9Yw6xMoxXa/C3OiLjJQbBRsJIFMtsM8r6q3bXwrWdpNQQA4fo75v9KPPANdoIyQwT4Om7ddcnyfAWruUUvGBsWkLnSBQX8PF6G6IM5b2OY6jIMBzSXrfVy7frAEjWxzR3oQdBYLranNrziKSBXfHPLz2II=
Message-ID: <45DA6E6D.5030700@gmail.com>
Date: Tue, 20 Feb 2007 12:43:41 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-ide@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Jeff Garzik <jeff@garzik.org>, Alan <alan@lxorguk.ukuu.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.20-git10 (and -git13): BUG at drivers/pci/pci.c:817 during
 resume from disk
References: <200702150016.24865.rjw@sisk.pl> <200702151223.44846.rjw@sisk.pl> <200702171100.39114.rjw@sisk.pl>
In-Reply-To: <200702171100.39114.rjw@sisk.pl>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> Update:
> 
> I get the same BUG with 2.6.20-git13 100% of the time during the resume.
> The system seems to be fully functional nonetheless.

Known bug, will be fixed soon.

-- 
tejun
