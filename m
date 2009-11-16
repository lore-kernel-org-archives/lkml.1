Return-Path: <linux-kernel-owner+w=401wt.eu-S1753357AbZKPQjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbZKPQjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 11:39:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbZKPQjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 11:39:52 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55150 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbZKPQjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 11:39:51 -0500
Date: Mon, 16 Nov 2009 16:39:46 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>, San Mehat <san@google.com>,
       Daniel Walker <dwalker@fifo99.com>, Iliyan Malchev <malchev@google.com>
Subject: Re: Status of Dream series
Message-ID: <20091116163946.GC3568@n2100.arm.linux.org.uk>
References: <20091111104748.GA26975@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091111104748.GA26975@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11, 2009 at 11:47:48AM +0100, Pavel Machek wrote:
> 
> Russell, what is the status of the "Dream" series? 
> 
>  [PATCH 1/3] msm: make debugging UART (for DEBUG_LL) configurable
>  [PATCH 2/3] msm: add minimal board file for HTC Dream device
>  [PATCH 3/3] msm: Add memory map for HTC Dream

See my reply today on patch 2/3; that is my only comment.

> Daniel Walker offered to maintain arch-msm tree, would that help? 

I thought from Daniel's private email to me on the 2/11 that this was
his intention; I didn't see a question in it requiring an answer.
