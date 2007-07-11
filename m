Return-Path: <linux-kernel-owner+w=401wt.eu-S932859AbXGKUvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932859AbXGKUvf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 16:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759232AbXGKUv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 16:51:26 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:15362 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758156AbXGKUvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 16:51:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=grYx7okYaxhFp4L+pjZqT1qsyWDASsO9sPj7zkXNQ8YawBS0m3reXl3A6unfDbdz96BX2QiMsQ5PLwQDFV1tXubCQt3YE4l4C/q+iuSOc6UXwywcW6ntbkEtcPNBRV3mLVdJvCeqv3PEYOf/M0lmVhb1/6c5OHGRqMcX4l+4AKc=
Subject: Re: [Linux-fbdev-devel] [GEODE] Add framebuffer support for the
	AMD Geode LX
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: Jordan Crouse <jordan.crouse@amd.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, info-linux@geode.amd.com,
       Ondrej Zajicek <santiago@crfreenet.org>
In-Reply-To: <20070710175039.GB32055@localhost.localdomain>
References: <20070709173211.GA6157@cosmic.amd.com>
	 <20070710175039.GB32055@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 12 Jul 2007 04:51:17 +0800
Message-Id: <1184187077.4504.11.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-10 at 19:50 +0200, Ondrej Zajicek wrote:
> On Mon, Jul 09, 2007 at 11:32:11AM -0600, Jordan Crouse wrote:

> If don't support panning, it should ensure that
> xres_virtual == xres and yres_virtual == yres
> 

There is no rule for this, but the above suggestion is preferred.

Tony

