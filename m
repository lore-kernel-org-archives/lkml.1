Return-Path: <linux-kernel-owner+w=401wt.eu-S1752495AbZIVVRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbZIVVRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 17:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbZIVVRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 17:17:30 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:48404 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbZIVVRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 17:17:30 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [resend] 2.6.31 regression: hangs on Compaq Evo N800c with ACPI enabled - bisected
Date: Tue, 22 Sep 2009 23:17:22 +0200
User-Agent: KMail/1.9.10
Cc: venkatesh.pallipadi@intel.com, len.brown@intel.com,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200909221709.24091.linux@rainbow-software.org> <200909222243.55403.rjw@sisk.pl>
In-Reply-To: <200909222243.55403.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909222317.24311.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 September 2009 22:43:55 Rafael J. Wysocki wrote:
> On Tuesday 22 September 2009, Ondrej Zary wrote:
> > Hello,
> > kernel 2.6.31 hangs during boot on Compaq Evo N800c laptop. 2.6.30 works
> > fine. See https://bugzilla.redhat.com/show_bug.cgi?id=522057
>
> Can you please file a kernel Bugzilla report for this issue, in the ACPI
> category?  The ACPI people use the kernel Bugzilla as the primary
> bug-tracking facility.

Thanks, here's the bug: http://bugzilla.kernel.org/show_bug.cgi?id=14211

-- 
Ondrej Zary
