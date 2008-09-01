Return-Path: <linux-kernel-owner+w=401wt.eu-S1756169AbYIATFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169AbYIATFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 15:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751608AbYIATFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 15:05:11 -0400
Received: from smtp100.biz.mail.mud.yahoo.com ([68.142.201.176]:26784 "HELO
	smtp100.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750831AbYIATFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 15:05:10 -0400
X-YMail-OSG: YZV.NG8VM1nOW9tiOQDj5S4Be8KNKQV8SehIbKUl4obCNDb6vonYHUztWxANQj3tj9ByuY04ckFR7ChWHKwsFqTGHITp46C6RTBuZ0EWiT5bVUzzaC0xMYF6H75yW_HrrwQ-
X-Yahoo-Newman-Property: ymail-3
From: Steven King <sfking@fdwdc.com>
Organization: fdwdc.com
To: Tomas Carnecky <tom@dbservice.com>
Subject: Re: 2.6.26.[1-3] + x61 tablet + x6ultrabase: no resume =?utf-8?q?after=09undocking?=
Date: Mon, 1 Sep 2008 12:05:04 -0700
User-Agent: KMail/1.9.9
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Zhang Rui <rui.zhang@intel.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net
References: <200808301535.22419.sfking@fdwdc.com> <20080901112816.GA21970@khazad-dum.debian.net> <48BBDD2C.5020804@dbservice.com>
In-Reply-To: <48BBDD2C.5020804@dbservice.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809011205.05253.sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 September 2008 5:16:44 Tomas Carnecky wrote:

> I just tested suspend/resume with the CDROM drive removed (an empty
> bay). Suspend/resume now works just fine, regardless how I dock/undock
> the laptop.

I'm seeing the exact same things as Tom.  Also, in my dmesg I see:

ACPI: \_SB_.PCI0.IDE0.PRIM.MSTR: found ejectable bay
ACPI: \_SB_.PCI0.IDE0.PRIM.MSTR: Adding notify handler
ACPI: Error installing bay notify handler

is this significant?


-- 
Steven King -- sfking at fdwdc dot com
