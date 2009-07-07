Return-Path: <linux-kernel-owner+w=401wt.eu-S1758421AbZGGUAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758421AbZGGUAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 16:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756242AbZGGUAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 16:00:43 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45252 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754655AbZGGUAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 16:00:43 -0400
Date: Tue, 7 Jul 2009 16:00:42 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Michael S. Zick" <lkml@morethan.org>
cc: Oliver Neukum <oliver@neukum.org>, Jiri Kosina <jkosina@suse.cz>,
       <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: Null Pointer BUG in uhci_hcd
In-Reply-To: <200907071451.08164.lkml@morethan.org>
Message-ID: <Pine.LNX.4.44L0.0907071559410.8221-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jul 2009, Michael S. Zick wrote:

> Will add that to my list - -
> I need to do that to find/fix that error path message flood loop in ehci anyway.

What EHCI message flood?

Alan Stern

