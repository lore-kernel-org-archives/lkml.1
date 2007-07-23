Return-Path: <linux-kernel-owner+w=401wt.eu-S935712AbXGWUZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935712AbXGWUZ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 16:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935592AbXGWUZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 16:25:29 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60191 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S935726AbXGWUZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 16:25:27 -0400
Date: Mon, 23 Jul 2007 13:25:26 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Andi Kleen <ak@suse.de>
Cc: "Joachim Deguara" <joachim.deguara@amd.com>,
       "lkml List" <linux-kernel@vger.kernel.org>, gregkh@suse.de,
       lenb@kernel.org, travis@sgi.com, steiner@sgi.com
Subject: Re: [PATCH 0/2] faking and fixing the NUMA SLIT
Message-ID: <20070723132526.5ce87f0d@schroedinger.engr.sgi.com>
In-Reply-To: <200707181142.20811.ak@suse.de>
References: <200707181130.01861.joachim.deguara@amd.com>
	<200707181142.20811.ak@suse.de>
Organization: Silicon Graphics, Inc.
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2007 11:42:20 +0200
Andi Kleen <ak@suse.de> wrote:

> Don't think that is really useful.

I think this is useful for NUMA debugging since one may use this to
create various slit configuration that can be useful to simulate many
fallback scenarios that may require testing.
