Return-Path: <linux-kernel-owner+w=401wt.eu-S1755571AbXD0K6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbXD0K6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 06:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755593AbXD0K6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 06:58:32 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:51206 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755571AbXD0K6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 06:58:31 -0400
Date: Fri, 27 Apr 2007 12:59:23 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Parav K Pandit <Parav_Pandit@mindtree.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: assembly code in the loadable kernel module
Message-ID: <20070427105923.GA31547@uranus.ravnborg.org>
References: <2C15D00D262B7245B1D8D1799F04D88F052A6F42@mtw01ex01.mindtree.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2C15D00D262B7245B1D8D1799F04D88F052A6F42@mtw01ex01.mindtree.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 02:15:48PM +0530, Parav K Pandit wrote:
> Hi,
> 
> I have written one function in assembly for my kernel module.
> Function is in module3.s file.
In the kernel assembeler files are named .S and preprocessed.
Try renaming it module3.S then it should work.

	Sam
