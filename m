Return-Path: <linux-kernel-owner+w=401wt.eu-S1756126Ab0ARVtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab0ARVtA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 16:49:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756041Ab0ARVs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 16:48:59 -0500
Received: from senator.holtmann.net ([87.106.208.187]:36510 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037Ab0ARVs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 16:48:58 -0500
Subject: Re: [PATCH] Add Linux Driver for Intel Langwell Watchdog
From: Marcel Holtmann <marcel@holtmann.org>
To: Mark Allyn <mark.a.allyn@intel.com>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, alan@linux.intel.com,
       charles.f.johnson@intel.com
In-Reply-To: <1263849859-23265-1-git-send-email-mark.a.allyn@intel.com>
References: <1263849859-23265-1-git-send-email-mark.a.allyn@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jan 2010 13:48:40 -0800
Message-ID: <1263851320.5591.150.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

> This patch adds a Linux device driver for the Intel Langwell
> Watchdog device found on the Intel Mobile Internet device.
> 
> The purpose of the watchdog driver is to force a system reboot
> in the event that a critical system process either terminates or
> gets currupted so that it cannot perform its required duties.
> 
> This patch is referenced off the linux-next repository as pulled
> on Sunday, January 17, 2010

please skip this message or put it after the diffstat and ---. It has no
useful information as commit message.

If we wanna provide extra details for the person applying these patches,
then after the --- (like the diffstat) is a good place. These are
showing up in the email and the archive, but are not part of the commit
message when the patch gets applied.

> Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>
> 
> Date: January 17, 2010

What is this Date field for?

Regards

Marcel


