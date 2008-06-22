Return-Path: <linux-kernel-owner+w=401wt.eu-S1755263AbYFVPn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbYFVPn6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 11:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbYFVPnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 11:43:47 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:55472 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbYFVPnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 11:43:46 -0400
Message-ID: <485E733D.8060109@keyaccess.nl>
Date: Sun, 22 Jun 2008 17:43:57 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Hans de Goede <j.w.r.degoede@hhs.nl>
CC: linux-acpi@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
       lm-sensors@lm-sensors.org, "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Zhang Rui <rui.zhang@intel.com>
Subject: Re: [lm-sensors] [REGRESSION, ABI] Re:  LMSENSORS: 2.6.26-rc, enabling
 ACPI Termal Zone support costs sensors
References: <485DA11C.7050906@keyaccess.nl> <485DFF35.6080008@hhs.nl> <485E505F.8010306@keyaccess.nl> <485E61DE.6020202@hhs.nl>
In-Reply-To: <485E61DE.6020202@hhs.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22-06-08 16:29, Hans de Goede wrote:

Oh, and...

> I wonder what just plain "sensors" (without the -s) does.

Same thing as sensors -s:

rene@7ixe4:~$ sensors 

Can't access procfs/sysfs file
Kernel interface access error
For 2.6 kernels, make sure you have mounted sysfs and libsensors
was compiled with sysfs support!

And no, the values are not being set by sensors -s, it's not just 
complaining but still working.

Rene.
