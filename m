Return-Path: <linux-kernel-owner+w=401wt.eu-S1752337AbZG3Gnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337AbZG3Gnl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 02:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751051AbZG3Gnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 02:43:41 -0400
Received: from poutre.nerim.net ([62.4.16.124]:53546 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbZG3Gnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 02:43:40 -0400
Date: Thu, 30 Jul 2009 08:43:36 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: i2c series import failure
Message-ID: <20090730084336.273a9ce6@hyperion.delvare>
In-Reply-To: <20090730104443.49df80a0.sfr@canb.auug.org.au>
References: <20090730104443.49df80a0.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Thu, 30 Jul 2009 10:44:43 +1000, Stephen Rothwell wrote:
> Today's linux-next import of the i2c series failed like this:
> 
> i2c-tsl2550-simpify-IO.patch
> error: patch failed: drivers/i2c/chips/tsl2550.c:24
> error: drivers/i2c/chips/tsl2550.c: patch does not apply
> 
> I will use the series from yesterday.

Sorry about that. I have just moved to a new flat and could not update
my published series yesterday (no Internet access.) This should be all
fixed now.

-- 
Jean Delvare
