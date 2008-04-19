Return-Path: <linux-kernel-owner+w=401wt.eu-S1759376AbYDSHXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759376AbYDSHXZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 03:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752790AbYDSHXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 03:23:15 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:1062 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbYDSHXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 03:23:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Io4M9U0mGJeUbp8Fr3kJiSWIU3r0UugfuuqxcukLAzWMiE8Xv/NJ9hdpSHtMu4eU5nZ3QfIHWteGPdomj+VpmiWdg+mUSnWA8MTfl6lxnKrAYcsb43GlxC0dwQP0APffB+d8VTmRuA2HbsRN9rxRdAipz5mondbcsxqSYC9uk2o=
Message-ID: <dd18b0c30804190023ka240e30u27f20fcbf4295a35@mail.gmail.com>
Date: Sat, 19 Apr 2008 00:23:14 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: latest git freezes my system
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I updated the latest git 2.6.25-02519-g3925e6f on my macbook pro, and
I seem to experiencing a system freeze on a given random number, i.g.
The system will run for five minuetes no problem, then a system
freeze, or during the boot process when the systems try's to load the
modules I'll receive a freeze
or I'll get the system up then within minuetes. Is there something I
need to add to my .config, or is this something more complex.
Also I'm seeing a no module symbols loaded kernel modules not enabled,
in /var/log/kern.log;  could this be related.
any help would be appreciated..

-- 
Justin P. Mattock
