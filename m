Return-Path: <linux-kernel-owner+w=401wt.eu-S1763200AbXJZCqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763200AbXJZCqV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 22:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756798AbXJZCqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 22:46:11 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:33187 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755596AbXJZCqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 22:46:10 -0400
Date: Thu, 25 Oct 2007 19:46:08 -0700
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, ak@suse.de, clameter@sgi.com,
       Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] mempolicy: mpol_rebind_policy cleanup
Message-Id: <20071025194608.245ccd2f.pj@sgi.com>
In-Reply-To: <alpine.DEB.0.9999.0710251913130.30400@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251912300.30400@chino.kir.corp.google.com>
	<alpine.DEB.0.9999.0710251913130.30400@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
> +	if (pol->policy != MPOL_DEFAULT)

Good catch - thanks.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
