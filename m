Return-Path: <linux-kernel-owner+w=401wt.eu-S1757857AbXK0UcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857AbXK0UcM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 15:32:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755356AbXK0Ub6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 15:31:58 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:48661 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755344AbXK0Ub6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 15:31:58 -0500
Date: Tue, 27 Nov 2007 15:31:57 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Andrew Morton <akpm@linux-foundation.org>, <kay.sievers@vrfy.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Kobjects: drop child->parent ref at unregistration
In-Reply-To: <20071127180742.GA2768@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0711271531170.3037-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Nov 2007, Greg KH wrote:

> Let me finish writing up this documentation on what I do remember and
> then I'll attack the block device patch and this one.

Be sure to CC: me when your documentation patch is sent out.

Alan Stern

