Return-Path: <linux-kernel-owner+w=401wt.eu-S1760173AbYBOSsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760173AbYBOSsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 13:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756859AbYBOSsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 13:48:05 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:55172 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776AbYBOSsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 13:48:04 -0500
Date: Fri, 15 Feb 2008 13:47:41 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, jack@suse.cz
Subject: Re: 2.6.24-mm1 bugs
Message-ID: <20080215184741.GB8810@c2.user-mode-linux.org>
References: <E1JPyyn-00055D-2i@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JPyyn-00055D-2i@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 12:43:45PM +0100, Miklos Szeredi wrote:
>  - UML doesn't boot: guest is 2.6.24-mm1 also, haven't tried any
>    other.  Same guest boots fine on 2.6.24 host.

What does it do?

Any chance you can bisect it?

				Jeff

-- 
Work email - jdike at linux dot intel dot com
