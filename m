Return-Path: <linux-kernel-owner+w=401wt.eu-S1763316AbXKNAz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763316AbXKNAz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 19:55:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759510AbXKNAzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 19:55:15 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759415AbXKNAzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 19:55:13 -0500
Message-ID: <473A476D.2000700@redhat.com>
Date: Tue, 13 Nov 2007 19:55:09 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Eric Schoeller <eric.schoeller@colorado.edu>
CC: linux-kernel@vger.kernel.org
Subject: Re: Enabling Magic SysRq Key on boot before INIT
References: <473A07E4.3050004@colorado.edu>
In-Reply-To: <473A07E4.3050004@colorado.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2007 03:24 PM, Eric Schoeller wrote:
> Hello,
> 
> I would like to enable the Magic SysRq key immediately when the linux
> kernel starts to boot, not when INIT begins. So, I am familiar with the
> sysctl command and /etc/sysctl.conf - but I'd like to modify these types
> of kernel variables earlier in the boot process. I thought that I could,
> perhaps, pass an argument to my "kernel" line in my bootloader (grub)
> configuration, but I have not been able to figure that out.
> 

sysrq_always_enabled

