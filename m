Return-Path: <linux-kernel-owner+w=401wt.eu-S1759239AbYF0Ohb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759239AbYF0Ohb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 10:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755081AbYF0OhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 10:37:16 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:46144 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604AbYF0OhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 10:37:15 -0400
Subject: Re: [PATCH 1/6] Extend completions to provide XFS object flush
	requirements
From: Daniel Walker <dwalker@mvista.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Dave Chinner <david@fromorbit.com>,
       xfs@oss.sgi.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080627091509.GA31148@infradead.org>
References: <1214455277-6387-1-git-send-email-david@fromorbit.com>
	 <1214455277-6387-2-git-send-email-david@fromorbit.com>
	 <1214512405.21035.110.camel@localhost.localdomain>
	 <20080627022407.GB7703@parisc-linux.org>
	 <1214537199.21035.179.camel@localhost.localdomain>
	 <20080627091509.GA31148@infradead.org>
Content-Type: text/plain
Date: Fri, 27 Jun 2008 07:37:12 -0700
Message-Id: <1214577432.21035.181.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-06-27 at 05:15 -0400, Christoph Hellwig wrote:
> On Thu, Jun 26, 2008 at 08:26:39PM -0700, Daniel Walker wrote:
> > Are you saying you want to keep semaphores? Cause I think that goes
> > against the overall agenda that I've seen,
> 
> Which overall agenda? 

Semaphore removal ..

Daniel

