Return-Path: <linux-kernel-owner+w=401wt.eu-S1761432AbYF0RMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761432AbYF0RMm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 13:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759431AbYF0RMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 13:12:25 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:41795 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758421AbYF0RMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 13:12:24 -0400
Date: Fri, 27 Jun 2008 11:08:30 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 18/20] um: use generic show_mem()
Message-ID: <20080627150830.GA8381@c2.user-mode-linux.org>
References: <20080627115349.743368154@saeurebad.de> <20080627120050.500232841@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080627120050.500232841@saeurebad.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 01:54:07PM +0200, Johannes Weiner wrote:
> Remove arch-specific show_mem() in favor of the generic version.

Still looks good for UML.

      	    	 Jeff

-- 
Work email - jdike at linux dot intel dot com
