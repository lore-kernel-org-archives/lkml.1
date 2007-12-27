Return-Path: <linux-kernel-owner+w=401wt.eu-S1752663AbXL0QOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbXL0QOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 11:14:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751335AbXL0QO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 11:14:26 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45062 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbXL0QOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 11:14:25 -0500
Date: Thu, 27 Dec 2007 16:13:57 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Pierre Savary <pierre.savary@kerlink.fr>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: syscall in a module
Message-ID: <20071227161357.GC31762@flint.arm.linux.org.uk>
References: <20071220091605.GC7921@flint.arm.linux.org.uk> <20071220101532.GA31128@flint.arm.linux.org.uk> <001101c842f6$3793a4b0$a6baee10$@savary@kerlink.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001101c842f6$3793a4b0$a6baee10$@savary@kerlink.fr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 11:50:59AM +0100, Pierre Savary wrote:
> Could you give me some sample, because I have no idea to how to send a
> uevent in userspace ...

TBH I don't know - only that my suggestion would be the most logical way
to go about it.  Maybe looking in MAINTAINERS and asking in a more
appropriate place would be more fruitful?

DRIVER CORE, KOBJECTS, AND SYSFS
P:      Greg Kroah-Hartman
M:      gregkh@suse.de
L:      linux-kernel@vger.kernel.org
T:      quilt kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
S:      Supported
