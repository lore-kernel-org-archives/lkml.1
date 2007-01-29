Return-Path: <linux-kernel-owner+w=401wt.eu-S965032AbXA2X5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965032AbXA2X5a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 18:57:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965015AbXA2X5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 18:57:30 -0500
Received: from tim.rpsys.net ([194.106.48.114]:44546 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965032AbXA2X53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 18:57:29 -0500
Subject: Re: Advice on APM-EMU reunion
From: Richard Purdie <rpurdie@rpsys.net>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <20070129230755.GA8705@enneenne.com>
References: <20070129230755.GA8705@enneenne.com>
Content-Type: text/plain
Date: Mon, 29 Jan 2007 23:53:46 +0000
Message-Id: <1170114826.5833.139.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-01-30 at 00:07 +0100, Rodolfo Giometti wrote:
> Now I try on this list in order to have some advice if this could be a
> good idea and what about if I add a new class "apm_emu" on the sysfs
> support with proper registrations functions.

I'm not sure this is a good idea. As you're creating a new interface,
why not create something new/improved without the problems that
confining yourself to APM emulation brings?

Regards,

Richard

