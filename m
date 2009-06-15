Return-Path: <linux-kernel-owner+w=401wt.eu-S1761696AbZFOOe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761696AbZFOOe4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 10:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761560AbZFOOer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 10:34:47 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:50824 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761032AbZFOOeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 10:34:46 -0400
Date: Mon, 15 Jun 2009 15:34:46 +0100
From: Matthew Garrett <mjg@redhat.com>
To: linux-input@vger.kernel.org, yanli@infradead.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, greg@kroah.com
Subject: Re: [PATCH] More i8042-reset quirks for MSI Wind-clone netbooks
Message-ID: <20090615143446.GB19451@srcf.ucam.org>
References: <20090615141613.GA7876@sage.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090615141613.GA7876@sage.bj.intel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 10:16:13PM +0800, Yan Li wrote:
> When testing Moblin on various netbooks, we've got reports that many
> MSI Wind clones need the i8042 reset quirks for the keyboard and/or
> touchpad's proper function.

Why are we not doing this unconditionally?
-- 
Matthew Garrett | mjg59@srcf.ucam.org
