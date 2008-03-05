Return-Path: <linux-kernel-owner+w=401wt.eu-S933105AbYCEXJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933105AbYCEXJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 18:09:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932667AbYCEXEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 18:04:42 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:32972 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765957AbYCEXEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 18:04:39 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: ACPI: WARNING: at arch/x86/mm/ioremap.c:138 __ioremap+0xa3/0x153()
Date: Thu, 6 Mar 2008 00:03:23 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
References: <20080305224155.GA10583@codemonkey.org.uk>
In-Reply-To: <20080305224155.GA10583@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803060003.23517.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 5 of March 2008, Dave Jones wrote:
>  > https://bugzilla.redhat.com/show_bug.cgi?id=436213
>  > 
>  >            Summary: WARNING: at arch/x86/mm/ioremap.c:138
>  >                     __ioremap+0xa3/0x153() (Not tainted)
>  >            Product: Fedora
>  >            Version: rawhide
>  >           Platform: i686
>  >         OS/Version: Linux
>  >             Status: NEW
>  >           Severity: low
>  >           Priority: low
>  >          Component: kernel
>  >         AssignedTo: kernel-maint@redhat.com
>  >         ReportedBy: orion@cora.nwra.com
>  >          QAContact: extras-qa@fedoraproject.org
>  > 
>  > 
>  > Description of problem:
>  > 
>  > Seeing this on a pentium M laptop during install.  Let me know what else you need.

This seems to be the same as http://bugzilla.kernel.org/show_bug.cgi?id=10104 .
