Return-Path: <linux-kernel-owner+w=401wt.eu-S1754772Ab0ATVhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab0ATVhj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 16:37:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754455Ab0ATVhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 16:37:38 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:59817 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754197Ab0ATVhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 16:37:37 -0500
Date: Wed, 20 Jan 2010 16:37:35 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [Update][RFC][PATCH] PM / Runtime: Add sysfs switch for disabling
 device run-time PM
In-Reply-To: <201001202209.29207.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1001201637001.1360-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jan 2010, Rafael J. Wysocki wrote:

> > Does anybody have a suggestion for a better attribute name?
> 
> Apparently not, but I can try. ;-)
> 
> * status
> 
> * power (power/power looks weird, but the values would make sense)
> 
> * control
> 
> No more ideas for now.

I vote for "control".

Alan Stern

