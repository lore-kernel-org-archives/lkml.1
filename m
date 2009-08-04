Return-Path: <linux-kernel-owner+w=401wt.eu-S933016AbZHDVXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933016AbZHDVXy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 17:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932598AbZHDVXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 17:23:54 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:50260 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932578AbZHDVXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 17:23:53 -0400
Subject: Re: [PATCH] flex_array: remove unneeded index calculation
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20090804133517.58429f31@bike.lwn.net>
References: <20090804133517.58429f31@bike.lwn.net>
Content-Type: text/plain
Date: Tue, 04 Aug 2009 14:23:51 -0700
Message-Id: <1249421031.11056.524.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-04 at 13:35 -0600, Jonathan Corbet wrote:
> flex_array_get() calculates an index value, then drops it on the floor;
> simply remove it.
> 
> Signed-off-by: Jonathan Corbet <corbet@lwn.net>

Looks good to me.  Thanks, Jonathan.


Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>

-- Dave

