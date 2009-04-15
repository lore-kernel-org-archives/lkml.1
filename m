Return-Path: <linux-kernel-owner+w=401wt.eu-S1756496AbZDOJvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496AbZDOJvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 05:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbZDOJvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 05:51:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37844 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752803AbZDOJvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 05:51:09 -0400
Date: Wed, 15 Apr 2009 10:51:04 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Eugene Teo <eugeneteo@kernel.sg>
Cc: Liam Girdwood <lg@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: remove extraneous semicolon
Message-ID: <20090415095104.GA20753@rakim.wolfsonmicro.main>
References: <20090415085222.GA12942@kernel.sg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090415085222.GA12942@kernel.sg>
X-Cookie: New crypt.  See /usr/news/crypt.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 04:52:22PM +0800, Eugene Teo wrote:
> An extraneous ";" after the if statement is a bad idea.
> 
> Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>

Someone sent the same patch a couple of days ago so that one might end
up getting merged instead but in any case

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
