Return-Path: <linux-kernel-owner+w=401wt.eu-S1757489AbYFEOSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489AbYFEOSw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 10:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755343AbYFEOSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 10:18:43 -0400
Received: from viefep31-int.chello.at ([62.179.121.49]:55518 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326AbYFEOSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 10:18:42 -0400
Subject: Re: [BUG] hotplug cpus on ia64
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: Cliff Wickman <cpw@sgi.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080605135128.GA22767@sgi.com>
References: <E1K1l2y-0007bu-44@eag09.americas.sgi.com>
	 <1212154614.12349.244.camel@twins> <20080603221759.GA19039@sgi.com>
	 <1212670198.23439.45.camel@twins>  <20080605135128.GA22767@sgi.com>
Content-Type: text/plain
Date: Thu, 05 Jun 2008 16:18:37 +0200
Message-Id: <1212675517.23439.46.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-05 at 08:51 -0500, Dimitri Sivanich wrote:
> On Thu, Jun 05, 2008 at 02:49:58PM +0200, Peter Zijlstra wrote:
> > 
> > Does the below fix it?
> > 
> 
> I don't believe so:

Humpfh :-( I'll continue looking then...

Thanks for testing.

