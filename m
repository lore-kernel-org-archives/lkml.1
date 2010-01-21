Return-Path: <linux-kernel-owner+w=401wt.eu-S1755463Ab0AUXBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab0AUXBY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 18:01:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755254Ab0AUXBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 18:01:16 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37889 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755065Ab0AUXBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 18:01:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 0/2] sysfs switch for disabling device run-time PM
Date: Thu, 21 Jan 2010 23:57:46 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>
References: <201001180129.55219.rjw@sisk.pl>
In-Reply-To: <201001180129.55219.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001212357.46483.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The first of the following two patches adds a sysfs switch for controlling the
run-time power management of devices and the second one documents the sysfs
attributes in /sys/devices/.../power/ (including the new one).

Thanks,
Rafael

