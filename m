Return-Path: <linux-kernel-owner+w=401wt.eu-S1751090Ab0AKKmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751090Ab0AKKmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 05:42:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750959Ab0AKKmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 05:42:32 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:50929 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab0AKKmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 05:42:31 -0500
Date: Mon, 11 Jan 2010 11:42:15 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Anton Blanchard <anton@samba.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 4/6] mips: cpumask_of_node() should handle -1 as a node
Message-ID: <20100111104215.GF13886@linux-mips.org>
References: <20100106045509.245662398@samba.org>
 <20100106045525.207405499@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100106045525.207405499@samba.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 06, 2010 at 03:55:13PM +1100, Anton Blanchard wrote:

> Subject: [patch 4/6] mips: cpumask_of_node() should handle -1 as a node

Thanks, applied!

  Ralf
