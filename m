Return-Path: <linux-kernel-owner+w=401wt.eu-S1756454AbZCYCOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454AbZCYCOy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 22:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754560AbZCYCOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 22:14:45 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48860 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754522AbZCYCOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 22:14:44 -0400
Message-ID: <49C9938C.9000700@garzik.org>
Date: Tue, 24 Mar 2009 22:14:36 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH] ahci: Blacklist HP Compaq 6720s that spins off disks
 during ACPI power off
References: <200903200006.46859.rjw@sisk.pl>
In-Reply-To: <200903200006.46859.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> From: Maciej Rutecki <maciej.rutecki@gmail.com>
> 
> Blacklist HP Compaq 6720s so that it doesn't play a "spin down,
> spin up, spin down" ping-pong with the hard disk during system
> power off.
> 
> Signed-off-by: Maciej Rutecki <maciej.rutecki@gmail.com>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

applied


