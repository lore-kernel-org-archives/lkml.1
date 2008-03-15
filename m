Return-Path: <linux-kernel-owner+w=401wt.eu-S1752996AbYCOCCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996AbYCOCCU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 22:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbYCOCCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 22:02:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420AbYCOCCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 22:02:08 -0400
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH update] firewire: fw-ohci: shut up false compiler warning on PPC32
Date: Fri, 14 Mar 2008 21:55:36 -0400
User-Agent: KMail/1.9.9
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <200803121743.27170.jwilson@redhat.com> <47D8679A.10303@s5r6.in-berlin.de> <tkrat.662a510489fead33@s5r6.in-berlin.de>
In-Reply-To: <tkrat.662a510489fead33@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803142155.36268.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 March 2008 07:27:49 pm Stefan Richter wrote:
> Shut up "may be used uninitialised in this function" warnings due to
> PPC32's implementation of dma_alloc_coherent().
>
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
>
> updated to be enqueued after patch
> "firewire: fw-ohci: use dma_alloc_coherent for ar_buffer"

Signed-off-by: Jarod Wilson <jwilson@redhat.com>

-- 
Jarod Wilson
jwilson@redhat.com
