Return-Path: <linux-kernel-owner+w=401wt.eu-S1754393AbYF0D07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393AbYF0D07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 23:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757601AbYF0D0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 23:26:44 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:32442 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756600AbYF0D0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 23:26:41 -0400
Subject: Re: [PATCH 1/6] Extend completions to provide XFS object flush
	requirements
From: Daniel Walker <dwalker@mvista.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080627022407.GB7703@parisc-linux.org>
References: <1214455277-6387-1-git-send-email-david@fromorbit.com>
	 <1214455277-6387-2-git-send-email-david@fromorbit.com>
	 <1214512405.21035.110.camel@localhost.localdomain>
	 <20080627022407.GB7703@parisc-linux.org>
Content-Type: text/plain
Date: Thu, 26 Jun 2008 20:26:39 -0700
Message-Id: <1214537199.21035.179.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-06-26 at 20:24 -0600, Matthew Wilcox wrote:

> 
> Then leave them as semaphores.  Really.
> 

Are you saying you want to keep semaphores? Cause I think that goes
against the overall agenda that I've seen, which is complete semaphore
removal .. If you have issues with the removal method then we could
change that ..

Daniel

