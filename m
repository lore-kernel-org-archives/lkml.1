Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960AbYHGMtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbYHGMtn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752321AbYHGMtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:49:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752298AbYHGMtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:49:32 -0400
Date: Thu, 7 Aug 2008 13:34:00 +0200
From: Karel Zak <kzak@redhat.com>
To: Pavel Machek <pavel@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       ACPI mailing list <linux-acpi@vger.kernel.org>
Subject: Re: 2.6.27-rc1: critical thermal shutdown on thinkpad x60
Message-ID: <20080807113400.GA18297@nb.net.home>
References: <20080806090246.GA1572@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080806090246.GA1572@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 11:02:47AM +0200, Pavel Machek wrote:
> Hi!
> 
> Aug  6 11:00:10 amd kernel: ACPI: Critical trip point
> Aug  6 11:00:10 amd kernel: Critical temperature reached (128 C),
> shutting down.
> Aug  6 11:00:10 amd shutdown[24414]: shutting down for system halt
> 
> ...and machine went down at that point :-(.

 It seems it like a bad day for ThinkPads:

Aug  6 20:05:36 nb kernel: ACPI: Critical trip point
Aug  6 20:05:36 nb kernel: Critical temperature reached (128 C),
shutting down.

 Kernel 2.6.26-136.fc10.x86_64 on x61.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
