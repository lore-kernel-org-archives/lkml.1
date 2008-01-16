Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbYAPP2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbYAPP2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 10:28:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbYAPP14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 10:27:56 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:41920 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751262AbYAPP1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 10:27:55 -0500
Date: Wed, 16 Jan 2008 10:27:54 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Dave Young <hidave.darkstar@gmail.com>
cc: Jarek Poplawski <jarkao2@gmail.com>, Greg KH <gregkh@suse.de>,
       <stefanr@s5r6.in-berlin.de>, <david-b@pacbell.net>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] driver-core : convert semaphore to mutex in struct
 class
In-Reply-To: <a8e1da0801151703w52df227en42eae85e75d5017f@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0801161026090.4431-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jan 2008, Dave Young wrote:

> The lockdep warining was posted in the below thread, actually, I have
> built and run this patced kernel for several days, there's no more
> warnings.
> http://lkml.org/lkml/2008/1/3/2

Your meaning isn't clear.  Do you mean that your patch doesn't generate
any lockdep warnings at all?  Or do you mean that it generates a single
lockdep warning at boot time and then no more warnings afterward?

Alan Stern

