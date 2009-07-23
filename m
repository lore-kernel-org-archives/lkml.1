Return-Path: <linux-kernel-owner+w=401wt.eu-S1754746AbZGWXw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbZGWXw5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 19:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754560AbZGWXw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 19:52:56 -0400
Received: from gate.crashing.org ([63.228.1.57]:53327 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754220AbZGWXwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 19:52:55 -0400
Subject: Re: [PATCH] powerpc: minor Makefile simplification through use of
 cc-ifversion
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Frans Pop <elendil@planet.nl>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
In-Reply-To: <20090723213132.GA9514@merkur.ravnborg.org>
References: <200907232057.19942.elendil@planet.nl>
	 <20090723213132.GA9514@merkur.ravnborg.org>
Content-Type: text/plain
Date: Fri, 24 Jul 2009 09:52:26 +1000
Message-Id: <1248393146.25467.13.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-23 at 23:31 +0200, Sam Ravnborg wrote:
> On Thu, Jul 23, 2009 at 08:57:18PM +0200, Frans Pop wrote:
> > Signed-off-by: Frans Pop <elendil@planet.nl>
> Acked-by: Sam Ravnborg <sam@ravnborg.org>

Thanks, will include in my next batch.

Cheers,
Ben.


