Return-Path: <linux-kernel-owner+w=401wt.eu-S1756042AbYLJHGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbYLJHGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 02:06:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754410AbYLJHGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 02:06:04 -0500
Received: from kroah.org ([198.145.64.141]:38509 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754266AbYLJHGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 02:06:03 -0500
Date: Tue, 9 Dec 2008 22:00:24 -0800
From: Greg KH <greg@kroah.com>
To: Srinivasan Jayarajan <srinivasan.jayarajan.lnxkrnl@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Controlling use of page cache for usb-storage disk access in a
	MIPS based embedded system
Message-ID: <20081210060024.GB30463@kroah.com>
References: <50fb67e90812042130m6274fb9bv110495a3a98ccb03@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50fb67e90812042130m6274fb9bv110495a3a98ccb03@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2008 at 11:00:19AM +0530, Srinivasan Jayarajan wrote:
> Hi,
> 
>   I have Linux 2.6.16-17 running on a MIPS development board.

That kernel is a few years old now, and is quite obsolete from a
community standpoint.  Have you tried a more recent version to see if
the same issues are present?

thanks,

greg k-h
