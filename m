Return-Path: <linux-kernel-owner+w=401wt.eu-S1760457AbXGERqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760457AbXGERqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 13:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758241AbXGERqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 13:46:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758076AbXGERqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 13:46:03 -0400
Message-ID: <468D2E59.9000902@redhat.com>
Date: Thu, 05 Jul 2007 13:46:01 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: yong Jung <yong_jk@yahoo.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: "libata ignore_hpa=1" doesn't wok on SATA ?
References: <932011.56083.qm@web54504.mail.re2.yahoo.com>
In-Reply-To: <932011.56083.qm@web54504.mail.re2.yahoo.com>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2007 08:00 PM, yong Jung wrote:
> Hi,
> .
> I would like to see the whole disk area and erase the
> hpa area in my desktop.
> At first I tried "setmax.c" program but it didn't work
> on SATA at least.
> So I upgraeded it to FC7 and added "libata
> ignore_hpa=1" option on boot command and
> /etc/modprobe.conf. 
> This option was accepted but still the kernel couldn't
> see the whole disk area even after reboot.

That's "libata.ignore_hpa=1"

