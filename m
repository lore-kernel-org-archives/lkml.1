Return-Path: <linux-kernel-owner+w=401wt.eu-S1754753AbYKKCFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbYKKCFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 21:05:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753765AbYKKCFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 21:05:42 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:47577 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbYKKCFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 21:05:41 -0500
Date: Tue, 11 Nov 2008 02:05:39 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Zhang Rui <rui.zhang@intel.com>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: ACPI crash on lid close - SMP race?
Message-ID: <20081111020539.GA11616@srcf.ucam.org>
References: <20081110161105.GA2041@srcf.ucam.org> <1226366834.15014.60.camel@rzhang-dt> <20081111013359.GA11364@srcf.ucam.org> <1226368778.15014.73.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226368778.15014.73.camel@rzhang-dt>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2008 at 09:59:38AM +0800, Zhang Rui wrote:

> oops. sorry, I mean system crashes on lid close if _DOS=0 on some UP
> platform.

Oh, ugh. I don't have any with that issue, but that ought to be 
"interesting" to fix.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
