Return-Path: <linux-kernel-owner+w=401wt.eu-S1754322AbZFRV1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322AbZFRV1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 17:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbZFRV1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 17:27:01 -0400
Received: from rosi.naasa.net ([212.8.0.13]:38884 "EHLO rosi.naasa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbZFRV1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 17:27:00 -0400
From: Joerg Platte <jplatte@naasa.net>
Reply-To: jplatte@naasa.net
To: Zhang Rui <rui.zhang@intel.com>
Subject: Re: [2.6.30] Kernel bug with dock driver
Date: Thu, 18 Jun 2009 23:26:56 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.30; KDE/4.2.4; i686; ; )
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>
References: <200906142100.48621.jplatte@naasa.net> <1245222796.9076.93.camel@rzhang-dt>
In-Reply-To: <1245222796.9076.93.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200906182326.57887.jplatte@naasa.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Wednesday, 17. June 2009 schrieb Zhang Rui:

> jplatte,
> it would be great if you can verify if this is a regression or not.

I'm not sure where to start. I'm not using the bay that frequent and the bug 
is not that easy to trigger. Sometimes I can trigger it directly, sometimes it 
takes a day.

> And please file a new bug report at
> http://bugzilla.kernel.org/enter_bug.cgi?product=ACPI
> attach the full dmesg after the bug and the acpidump output there.

I'll file a bug if Henrique is unable to find the bug. Maybe his debugging 
output helps to find the problem.

regards,
Jörg
