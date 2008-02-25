Return-Path: <linux-kernel-owner+w=401wt.eu-S1756199AbYBYF3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbYBYF3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 00:29:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbYBYF3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 00:29:43 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:2128 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbYBYF3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 00:29:43 -0500
Date: Mon, 25 Feb 2008 05:30:52 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: Re: [RFC/PATCH] Update coding standard to avoid ungrepable printk format strings
Message-ID: <20080225053052.GB2604@shadowen.org>
References: <20080222132612.GA11717@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080222132612.GA11717@basil.nowhere.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 02:26:12PM +0100, Andi Kleen wrote:

> At some point checkpatch.pl would need to be updated to know about this
> exception too, that would be the next step.

Cirtainly we have exceptions for docstrings, so that shouldn't be a
problem if this were accepted.

-apw
