Return-Path: <linux-kernel-owner+w=401wt.eu-S1757045AbXJ3VIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045AbXJ3VIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 17:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbXJ3VI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 17:08:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42129 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944AbXJ3VI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 17:08:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [2.6.24-rc1 regression] AC adapter state does not change after resume
Date: Tue, 30 Oct 2007 22:24:55 +0100
User-Agent: KMail/1.9.5
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200710302324.52822.arvidjaar@mail.ru>
In-Reply-To: <200710302324.52822.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710302224.55947.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 30 October 2007 21:24, Andrey Borzenkov wrote:
> I suspect new ACPI AC adapter code but have to add some printk's to be sure.
> 
> To reproduce - plug in AC cord, suspend, unplug, resume - kpowersave and sysfs 
> still show AC adapter online. Or other way round.

Is this a resume from RAM or from disk?

Does 2.6.23 work correctly?

Rafael
