Return-Path: <linux-kernel-owner+w=401wt.eu-S1753286AbZDOP7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbZDOP7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 11:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbZDOP7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 11:59:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:40445 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbZDOP7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 11:59:13 -0400
Subject: Re: [PATCH] regulator: remove extraneous semicolon
From: Liam Girdwood <lrg@kernel.org>
To: Eugene Teo <eugeneteo@kernel.sg>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090415095104.GA20753@rakim.wolfsonmicro.main>
References: <20090415085222.GA12942@kernel.sg>
	 <20090415095104.GA20753@rakim.wolfsonmicro.main>
Content-Type: text/plain
Date: Wed, 15 Apr 2009 16:58:54 +0100
Message-Id: <1239811134.27410.1801.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-15 at 10:51 +0100, Mark Brown wrote:
> On Wed, Apr 15, 2009 at 04:52:22PM +0800, Eugene Teo wrote:
> > An extraneous ";" after the if statement is a bad idea.
> > 
> > Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
> 
> Someone sent the same patch a couple of days ago so that one might end
> up getting merged instead but in any case
> 

Thanks, I've just applied the earlier patch as it was first in my inbox.

Liam

