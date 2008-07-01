Return-Path: <linux-kernel-owner+w=401wt.eu-S1760841AbYGAWRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760841AbYGAWRu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 18:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753891AbYGAWRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 18:17:42 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57379 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbYGAWRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 18:17:42 -0400
Date: Tue, 1 Jul 2008 23:17:32 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: RFC: Add mtdset= to Documentation/kernel-parameters
Message-ID: <20080701221732.GA16816@flint.arm.linux.org.uk>
References: <20080701215726.GA22880@fluff.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701215726.GA22880@fluff.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 10:57:26PM +0100, Ben Dooks wrote:
> Does anyone have any comments about adding this patch
> to describe the ARM/S3C2412 Jive machine specific kernel
> commandline parameter mtdset?

Only that it should be part of the patch which adds the mtdset=
parameter rather than a separate stand alone patch.
