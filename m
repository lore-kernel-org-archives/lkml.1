Return-Path: <linux-kernel-owner+w=401wt.eu-S1758599AbYA1OzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599AbYA1OzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 09:55:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbYA1OzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 09:55:09 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:4836 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330AbYA1OzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 09:55:08 -0500
Date: Mon, 28 Jan 2008 14:56:05 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Change a WARN message in checkpatch
Message-ID: <20080128145605.GI12910@shadowen.org>
References: <20080114232913.2555d392@paolo-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114232913.2555d392@paolo-desktop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 11:29:13PM +0100, Paolo Ciarrocchi wrote:
> Hi Andy,
> When I started using checkpatch I was confused by the following WARN message:
> 
> 	no space between function name and open parenthesis
> 
> I thought the problem was that a space was missing while the truth is the opposite.
> 
> How about the following patch?

I can see how that language would be confusing.  Your patch makes the
english clearer, but somehow seems clumsy.  There must be a better way
to say this.  I will think on it and see what I can come up with.

-apw
