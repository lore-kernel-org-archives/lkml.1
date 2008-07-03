Return-Path: <linux-kernel-owner+w=401wt.eu-S1761515AbYGCIbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761515AbYGCIbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 04:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbYGCIRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 04:17:32 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50835 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937025AbYGCHpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 03:45:24 -0400
Date: Thu, 3 Jul 2008 08:45:11 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Marek Va??ut <marek.vasut@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] PalmTX initial support
Message-ID: <20080703074511.GA14481@flint.arm.linux.org.uk>
References: <200807022232.47294.marek.vasut@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807022232.47294.marek.vasut@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2008 at 10:32:47PM +0200, Marek Va??ut wrote:
> the following patch adds initial support for PalmTX handheld computer. It 
> originates from HnD kernel tree (www.hackndev.com), then I pushed it to 
> handhelds.org and now I'd like it to be applied mainline.

There's one other thing that's missing from the patch - an entry for
MAINTAINERS.
