Return-Path: <linux-kernel-owner+w=401wt.eu-S1754076Ab0AWUMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab0AWUMT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 15:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753953Ab0AWUMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 15:12:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43127 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636Ab0AWUMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 15:12:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: High pitch noise when ACPI processor module is loaded.
Date: Sat, 23 Jan 2010 21:12:57 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
References: <alpine.DEB.2.00.1001231046080.1064@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.00.1001231046080.1064@p34.internal.lan>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001232112.57601.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Messages about ACPI should be CCed to linux-acpi@vger.kernel.org (added).

On Saturday 23 January 2010, Justin Piszcz wrote:
> Hi,
> 
> Linux:
> When I do not load the ACPI processor module, there is no high pitch 
> noise.  When I load the ACPI processor module (so I can utilize Turbo 
> Boost), Linux makes the system emit a high pitch noise.
> 
> Windows:
> The same system, running Windows 7 does not emit any noise.
> 
> Is there something wrong with the ACPI processor module or its 
> implementation on i5/i7 CPUs?
> 
> Justin.
