Return-Path: <linux-kernel-owner+w=401wt.eu-S1758461AbXK0Jar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758461AbXK0Jar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 04:30:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754098AbXK0Jaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 04:30:39 -0500
Received: from cantor.suse.de ([195.135.220.2]:60712 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951AbXK0Jai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 04:30:38 -0500
From: Andreas Schwab <schwab@suse.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, tony.luck@intel.com
Subject: Re: [patch 04/14] ia64: Remove the __SMALL_ADDR_AREA attribute for per cpu access
References: <20071127001407.859743255@sgi.com>
	<20071127001430.083503280@sgi.com>
X-Yow: I wish I was a sex-starved manicurist found dead in the Bronx!!
Date: Tue, 27 Nov 2007 10:30:36 +0100
In-Reply-To: <20071127001430.083503280@sgi.com> (Christoph Lameter's message
	of "Mon\, 26 Nov 2007 16\:14\:11 -0800")
Message-ID: <jehcj83uir.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter <clameter@sgi.com> writes:

> The model(small) attribute is not supported by gcc 4.X.

Which gcc 4.X are you talking about?

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
