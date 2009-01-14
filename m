Return-Path: <linux-kernel-owner+w=401wt.eu-S1764561AbZANQt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764561AbZANQt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 11:49:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761919AbZANQtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 11:49:49 -0500
Received: from c60.cesmail.net ([216.154.195.49]:32042 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754743AbZANQts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 11:49:48 -0500
Subject: Re: checkpatch confused by pre-existing #endif
From: Pavel Roskin <proski@gnu.org>
To: Andy Whitcroft <apw@canonical.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090114164539.GD10653@shadowen.org>
References: <1231883863.21706.17.camel@dv>
	 <20090114164539.GD10653@shadowen.org>
Content-Type: text/plain
Date: Wed, 14 Jan 2009 11:49:42 -0500
Message-Id: <1231951782.29339.5.camel@dv>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-3.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-14 at 16:45 +0000, Andy Whitcroft wrote:

> Yes this should be fixed in the changes pushed up to Andrew.  You can
> confirm this using the version here:
> 
>   http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-testing

It's working fine on the ath9k patchset where the issue was discovered.
Thank you!

-- 
Regards,
Pavel Roskin
