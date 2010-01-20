Return-Path: <linux-kernel-owner+w=401wt.eu-S1752246Ab0ATPJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab0ATPJJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 10:09:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874Ab0ATPJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 10:09:07 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:38583 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751147Ab0ATPJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 10:09:06 -0500
Date: Wed, 20 Jan 2010 10:09:03 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [Update][RFC][PATCH] PM / Runtime: Add sysfs switch for disabling
 device run-time PM
In-Reply-To: <201001192132.26765.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1001201005380.1672-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jan 2010, Rafael J. Wysocki wrote:

> > Why change the name from "level" to "runtime"?
> 
> Because it wouldn't be really obvious what "level" applied to.  For example,
> some people might expect the values of "level" to correspond to PCI power
> states for PCI devices and so on, so it might turn out to be confusing. 

But is the name "runtime" any clearer?  Especially to people who have 
never come across the phrase "runtime power management"?

Does anybody have a suggestion for a better attribute name?

Alan Stern

