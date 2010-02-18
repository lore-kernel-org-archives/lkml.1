Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758291Ab0BRPHY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 10:07:24 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:31045 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757402Ab0BRPHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 10:07:22 -0500
Date: Thu, 18 Feb 2010 09:10:24 -0600
From: scameron@beardog.cce.hp.com
To: dann frazier <dannf@hp.com>
Cc: axboe@kernel.dk, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       mikem@beardog.cce.hp.com, brace@beardog.cce.hp.com
Subject: Re: [PATCH 2/2] cciss: Consolidate duplicate bits in cciss_cmd.h & cciss_ioctl.h
Message-ID: <20100218151024.GB30797@beardog.cce.hp.com>
References: <20100217235331.GC12240@ldl.fc.hp.com> <20100217235511.GD12240@ldl.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100217235511.GD12240@ldl.fc.hp.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 17, 2010 at 04:55:11PM -0700, dann frazier wrote:
> There are several duplicate definitions in cciss_cmd.h and cciss_ioctl.h.
> Consolidate these into the new cciss_defs.h file. This patch doesn't change
> the definitions exposed under include/linux, so userspace apps shouldn't
> be affected.
> 
> Signed-off-by: dann frazier <dannf@hp.com>

Acked-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>

