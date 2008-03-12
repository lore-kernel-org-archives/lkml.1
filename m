Return-Path: <linux-kernel-owner+w=401wt.eu-S1755404AbYCLWmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbYCLWmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 18:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbYCLWme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 18:42:34 -0400
Received: from ozlabs.org ([203.10.76.45]:38631 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbYCLWmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 18:42:33 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: virtualization@lists.linux-foundation.org
Subject: Re: [patch 0/6] Guest page hinting version 6.
Date: Thu, 13 Mar 2008 09:41:47 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, virtualization@lists.osdl.org,
       akpm@osdl.org, nickpiggin@yahoo.com.au, frankeh@watson.ibm.com,
       hugh@veritas.com
References: <20080312132132.520833247@de.ibm.com>
In-Reply-To: <20080312132132.520833247@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803130941.48480.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 March 2008 00:21:32 Martin Schwidefsky wrote:
> My question now is how to proceed with the code. I sure
> would love to see the code going upstream some day but that depends on
> the mm developers as the code adds complexity that needs to be supported.

Well, I want this feature, but I agree about complexity.

AFAICT, the trivial subset of this is the hinting of Unused pages.  It seems 
that would buy us something, and perhaps be a stepping stone to full page 
hinting?

Cheers,
Rusty.
