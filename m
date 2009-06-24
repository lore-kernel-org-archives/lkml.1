Return-Path: <linux-kernel-owner+w=401wt.eu-S1759292AbZFXRMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759292AbZFXRMn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 13:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755606AbZFXRMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 13:12:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:48970 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436AbZFXRMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 13:12:35 -0400
Subject: Re: [RFC] x86: gup_fast() batch limit
From: Peter Zijlstra <peterz@infradead.org>
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
In-Reply-To: <4A422E22.6020801@inria.fr>
References: <1238017510-26784-1-git-send-email-eric@anholt.net>
	 <1238242929.4039.706.camel@laptop> <1238244374.4039.743.camel@laptop>
	 <200904022219.53949.nickpiggin@yahoo.com.au>  <4A422E22.6020801@inria.fr>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 24 Jun 2009 19:07:18 +0200
Message-Id: <1245863238.31755.20.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-24 at 15:46 +0200, Brice Goglin wrote:
> Any news about this patch?

I knew I was forgetting something, I'll try and find a hole to
ressurect/finish this ;-)

