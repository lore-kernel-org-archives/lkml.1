Return-Path: <linux-kernel-owner+w=401wt.eu-S1760175AbYA0XGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760175AbYA0XGT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 18:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbYA0XGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 18:06:04 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:35503 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbYA0XGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 18:06:00 -0500
Subject: Re: [PATCH] [10/18] BKL-removal: Implement a compat_ioctl handler
	for JFS
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, akpm@osdl.org
In-Reply-To: <20080127021716.BE0B714D2E@wotan.suse.de>
References: <20080127317.043953000@suse.de>
	 <20080127021716.BE0B714D2E@wotan.suse.de>
Content-Type: text/plain
Date: Sun, 27 Jan 2008 17:05:41 -0600
Message-Id: <1201475141.11997.37.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-01-27 at 03:17 +0100, Andi Kleen wrote:
> The ioctls were already compatible except for the actual values so this
> was fairly easy to do.
> 
> Cc: shaggy@austin.ibm.com
> 
> Signed-off-by: Andi Kleen <ak@suse.de>

Added to the jfs git tree.

Thanks,
Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

