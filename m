Return-Path: <linux-kernel-owner+w=401wt.eu-S1765797AbZFLTsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765797AbZFLTsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 15:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759215AbZFLTsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 15:48:32 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36095 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761039AbZFLTsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 15:48:31 -0400
Date: Fri, 12 Jun 2009 15:48:33 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Oliver Neukum <oliver@neukum.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch update] Re: [linux-pm] Run-time PM idea (was: Re:
 [RFC][PATCH 0/2] PM: Rearrange core suspend code)
In-Reply-To: <200906122109.35589.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0906121547490.2862-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jun 2009, Rafael J. Wysocki wrote:

> So, are you suggesting that the core should only check the "all children
> suspended" condition if special flag is set in dev_pm_info?

Or rather, check it only if the special flag _isn't_ set.

Alan Stern

