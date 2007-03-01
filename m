Return-Path: <linux-kernel-owner+w=401wt.eu-S965462AbXCARuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965462AbXCARuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 12:50:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965466AbXCARuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 12:50:40 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965462AbXCARue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 12:50:34 -0500
Date: Thu, 1 Mar 2007 12:48:06 -0500
From: Dave Jones <davej@redhat.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Pavel Machek <pavel@ucw.cz>, Chuck Ebbert <cebbert@redhat.com>,
       Rudolf Marek <r.marek@assembler.cz>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
Message-ID: <20070301174806.GA4979@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jean Delvare <khali@linux-fr.org>, Pavel Machek <pavel@ucw.cz>,
	Chuck Ebbert <cebbert@redhat.com>,
	Rudolf Marek <r.marek@assembler.cz>, linux-acpi@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>,
	lm-sensors@lm-sensors.org
References: <45D5EA88.7090300@redhat.com> <45D6DDCE.5050803@assembler.cz> <45D7461A.2040808@redhat.com> <20070218183805.5a4fd813.khali@linux-fr.org> <20070228213803.GA4877@ucw.cz> <20070301152655.f232db64.khali@linux-fr.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070301152655.f232db64.khali@linux-fr.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 03:26:55PM +0100, Jean Delvare wrote:

 > Firstly, the first records of hidden SMBus, in September 2000, predate
 > ACPI.

The earliest ACPI spec I have handy is 1.0b, which came out in Feb 2 1999
so this isn't true. The all knowing (and always accurate :) wikipedia
claims it was first released in 1996, though I believe that all the pre 1.0b
machines were using acpi implementations before the standard was finalised.

I certainly remember seeing ACPI capable machines circa 1997/1998.

		Dave

-- 
http://www.codemonkey.org.uk
