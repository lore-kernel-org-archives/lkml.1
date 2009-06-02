Return-Path: <linux-kernel-owner+w=401wt.eu-S1760338AbZFBLQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760338AbZFBLQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 07:16:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756400AbZFBLPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 07:15:55 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:48695 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756072AbZFBLPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 07:15:55 -0400
Date: Tue, 2 Jun 2009 12:15:11 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Florian Fainelli <florian@openwrt.org>
Cc: linux-kernel@vger.kernel.org, akpm <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/9] drivers: wire in vlynq bus support
Message-ID: <20090602111511.GB11488@linux-mips.org>
References: <200906011359.09622.florian@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906011359.09622.florian@openwrt.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 01, 2009 at 01:59:08PM +0200, Florian Fainelli wrote:

> This patch allows the VLYNQ bus support
> to be selected and compiled.

This patch on its own doesn't really make sense.  Please fold it into 2/9.

  Ralf
