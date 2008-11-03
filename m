Return-Path: <linux-kernel-owner+w=401wt.eu-S1756013AbYKCOY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013AbYKCOY7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 09:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755180AbYKCOYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 09:24:50 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:8601 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbYKCOYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 09:24:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=J2oXKwpSAGxaCO3vAgbdswHRd5bRKs06RAnsAZekAlPNxxQV8p2RGkWez5X8pqr+fC
         GP7P5SLUOKggKwGVU7p/8bBslzkUjXFX6PQJ356XsWi6Vb28bC5Fj6kr2oeYCDv3iqYF
         2i7LpCdXiJ+SHwp+w5hj5BQ+hQRzvPFyKmVmA=
Date: Mon, 3 Nov 2008 17:28:01 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       rmk+kernel@arm.linux.org.uk
Subject: next-20081103: arch/arm/kernel/elf.c:30: error: 'e_flags'
	undeclared
Message-ID: <20081103142801.GA3918@x200.localdomain>
References: <20081103183214.aac32543.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081103183214.aac32543.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s/e_flags/eflags/ but I'm not sure.
