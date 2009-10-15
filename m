Return-Path: <linux-kernel-owner+w=401wt.eu-S1762409AbZJOIMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762409AbZJOIMF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 04:12:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762035AbZJOIME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 04:12:04 -0400
Received: from poutre.nerim.net ([62.4.16.124]:50576 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761991AbZJOIMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 04:12:03 -0400
Date: Thu, 15 Oct 2009 10:11:15 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Krzysztof Helt <krzysztof.h1@wp.pl>
Subject: Re: [Patch] i2c: remove deprecated i2c-voodoo3 driver
Message-ID: <20091015101115.6fc032d7@hyperion.delvare>
In-Reply-To: <20091015064805.4448.50695.sendpatchset@localhost.localdomain>
References: <20091015064805.4448.50695.sendpatchset@localhost.localdomain>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009 02:45:23 -0400, Amerigo Wang wrote:
> 
> This driver is scheduled to be removed now.

... and is already removed. Just look at linux-next.

ftp://ftp.kernel.org/pub/linux/kernel/people/jdelvare/linux-2.6/jdelvare-i2c/i2c-voodoo3-delete.patch

-- 
Jean Delvare
