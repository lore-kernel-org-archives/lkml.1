Return-Path: <linux-kernel-owner+w=401wt.eu-S1752379AbXCULZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbXCULZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 07:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752342AbXCULZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 07:25:33 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59608 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbXCULZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 07:25:32 -0400
Subject: Re: [PATCH] Complain about missing system calls.
From: David Woodhouse <dwmw2@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       rmk@arm.linux.org.uk, sam@ravnborg.org
In-Reply-To: <20070319164243.026fdbfd.akpm@linux-foundation.org>
References: <1173394873.3461.510.camel@pmac.infradead.org>
	 <20070319164243.026fdbfd.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 21 Mar 2007 11:25:30 +0000
Message-Id: <1174476330.20505.54.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6.dwmw2.1) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-19 at 16:42 -0700, Andrew Morton wrote:
> hm, did you try running this on x86_64?

git://git.infradead.org/~dwmw2/syscalls-2.6.git

Should make it quieter on ARM and x86_64, and includes Stéphane's patch
to make it work with dash.

-- 
dwmw2

