Return-Path: <linux-kernel-owner+w=401wt.eu-S1755862AbYJWMN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbYJWMN5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 08:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbYJWMNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 08:13:48 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:42788 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbYJWMNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 08:13:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OjaudcBRLVCEdh9wknXSpKFcXq+KMzO9iRwryjy2OFPkwlufQIYRLr/pVVGODuDvke
         dmrr5l3xirbsmFCm+UWq2ofhE8DJbrqrgtlSCGgUIx6Id8LdAY7WpbbnWkoltwwVhXRF
         zw2exggTE7EV+w3lRnLOOQUx604JGxj2YAO8g=
Date: Thu, 23 Oct 2008 16:16:56 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au
Subject: Re: linux-next: arch/alpha/include/asm/smp.h:48:1: error:
	"cpu_possible_map" redefined
Message-ID: <20081023121656.GD27984@x200.localdomain>
References: <20081023213637.eff9b414.sfr@canb.auug.org.au> <20081023121550.GC27984@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023121550.GC27984@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 04:15:50PM +0400, Alexey Dobriyan wrote:
> On alpha-smp-y-debug-n:

Debug part is irrelevant, all alpha-smp-y is broken.
