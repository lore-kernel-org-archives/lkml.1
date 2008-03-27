Return-Path: <linux-kernel-owner+w=401wt.eu-S1757673AbYC0Csa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757673AbYC0Csa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 22:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753701AbYC0CsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 22:48:21 -0400
Received: from netrider.rowland.org ([192.131.102.5]:1029 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754569AbYC0CsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 22:48:20 -0400
Date: Wed, 26 Mar 2008 22:48:19 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Oliver Neukum <oliver@neukum.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       <linux-pm@lists.linux-foundation.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [RFC][PATCH] PM: Introduce new top level
 =?iso-8859-1?q?suspend=09and_hibernation_callbacks?= (rev. 2)
In-Reply-To: <200803262146.39899.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0803262246460.21714-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2008, Rafael J. Wysocki wrote:

> What exactly do you whink would be wrong with using the error codes to avoid
> resuming the children of devices that failed to resume?

Nothing, I guess.  Drivers should work okay either way.

Alan Stern

