Return-Path: <linux-kernel-owner+w=401wt.eu-S932383AbZKDRmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383AbZKDRmM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:42:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757572AbZKDRmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:42:09 -0500
Received: from outbound-mail-12.bluehost.com ([69.89.18.112]:57634 "HELO
	outbound-mail-12.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932311AbZKDRmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:42:07 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=U01CkszE8rUKnmUR4H7Fwervk+qY7ysJheNOuECYp5KyVVrx3rE/c8pdeH1gvr6JLRBrdf+xYMjkAEK/yenJZBE9Ip1CKN4mqd+ShvYzTOYLsN5K6nRKQBFmQLGtWpTb;
Date: Wed, 4 Nov 2009 09:42:09 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Gabe Black <gabe.black@ni.com>
Cc: shawn.bohrer@ni.com, mike.hoogendyk@ni.com, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, Gabe Black <gabe.black@ni.com>
Subject: Re: [PATCH] Populate subsystem vendor and device IDs for
 PCI-Bridges
Message-ID: <20091104094209.68f68381@jbarnes-piketon>
In-Reply-To: <1254843919-13809-1-git-send-email-gabe.black@ni.com>
References: <1254843919-13809-1-git-send-email-gabe.black@ni.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Oct 2009 10:45:19 -0500
Gabe Black <gabe.black@ni.com> wrote:

> Change to populate the subsystem vendor and subsytem device IDs for
> PCI-PCI bridges that implement the PCI Subsystem Vendor ID capability.
> Previously bridges left subsystem vendor IDs unpopulated.
> 
> Signed-off-by: Gabe Black <gabe.black@ni.com>

Applied to my linux-next branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
