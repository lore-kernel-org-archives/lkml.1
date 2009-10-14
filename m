Return-Path: <linux-kernel-owner+w=401wt.eu-S933397AbZJNDaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933397AbZJNDaM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 23:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754632AbZJNDaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 23:30:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:56138 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753628AbZJNDaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 23:30:11 -0400
Subject: Re: New percpu & ppc64 perfs
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Tejun Heo <tj@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linuxppc-dev@lists.ozlabs.org
In-Reply-To: <4AD52E37.80209@kernel.org>
References: <1255478358.2347.28.camel@pasglop>  <4AD52E37.80209@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Oct 2009 14:28:31 +1100
Message-Id: <1255490911.2347.32.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-14 at 10:49 +0900, Tejun Heo wrote:
> For 256M segment, I don't think much can be done but for 1T segment,
> just limiting vmalloc area size to 1T should do the trick, no?

Right. I'll have a look at it.

Cheers,
Ben.


