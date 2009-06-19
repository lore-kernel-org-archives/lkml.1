Return-Path: <linux-kernel-owner+w=401wt.eu-S1752607AbZFSWWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbZFSWWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 18:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbZFSWWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 18:22:23 -0400
Received: from khc.piap.pl ([195.187.100.11]:42905 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbZFSWWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 18:22:23 -0400
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Marcel Holtmann <marcel@holtmann.org>, Dave Airlie <airlied@linux.ie>,
       Keith Packard <keithp@keithp.com>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net
Subject: Re: Trivial fixes for drivers/gpu/drm/i915/
References: <m34ouc55ka.fsf@intrepid.localdomain>
	<1245443718.15367.46.camel@violet> <4A3C00E7.9020808@oracle.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sat, 20 Jun 2009 00:22:22 +0200
In-Reply-To: <4A3C00E7.9020808@oracle.com> (Randy Dunlap's message of "Fri\, 19 Jun 2009 14\:19\:35 -0700")
Message-ID: <m3tz2b50f5.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap <randy.dunlap@oracle.com> writes:

> I.e., using %zd or %zu is the preferred fix.

Good to know, thanks.
-- 
Krzysztof Halasa
