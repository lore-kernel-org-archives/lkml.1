Return-Path: <linux-kernel-owner+w=401wt.eu-S1161607AbXD3AKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161607AbXD3AKl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 20:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161602AbXD3AKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 20:10:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161607AbXD3AJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 20:09:59 -0400
Date: Sun, 29 Apr 2007 20:09:48 -0400
From: Dave Jones <davej@redhat.com>
To: Andi Kleen <ak@suse.de>
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [19/26] i386: Enable bank 0 on non K7 Athlon
Message-ID: <20070430000948.GC14857@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Andi Kleen <ak@suse.de>,
	patches@x86-64.org, linux-kernel@vger.kernel.org
References: <20070430146.588463000@suse.de> <20070429234628.F1E2C151C5@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070429234628.F1E2C151C5@wotan.suse.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 01:46:28AM +0200, Andi Kleen wrote:
 > 
 > As a bug workaround bank 0 on K7s is normally disabled, but no need
 > to do that on other AMD CPUs.
 > 
 > Cc: davej@redhat.com
 > 
 > Signed-off-by: Andi Kleen <ak@suse.de>
 
ACK, looks good to me.

thanks,

	Dave

-- 
http://www.codemonkey.org.uk
