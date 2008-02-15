Return-Path: <linux-kernel-owner+w=401wt.eu-S1762192AbYBOXUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762192AbYBOXUd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 18:20:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752882AbYBOXUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 18:20:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:53991 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753269AbYBOXUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 18:20:24 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [patch] move wakeup code to .c
Date: Fri, 15 Feb 2008 18:19:23 -0500
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>, hpa@zytor.com,
       sam@ravnborg.org
References: <20080210222723.GA1865@elf.ucw.cz> <200802150135.07127.lenb@kernel.org> <200802152322.23392.rjw@sisk.pl>
In-Reply-To: <200802152322.23392.rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200802151819.23413.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 February 2008 17:22, Rafael J. Wysocki wrote:

> Ok, below is the version that survives checkpatch.pl, compiles on x86-32
> and has been successfully tested on 32-bit and 64-bit systems.

works on my t61 in 64-bit mode too.

applied to acpi-test.

thanks,
-Len
