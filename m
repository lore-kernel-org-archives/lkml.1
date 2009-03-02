Return-Path: <linux-kernel-owner+w=401wt.eu-S1758723AbZCBIJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723AbZCBIJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 03:09:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756750AbZCBIJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 03:09:16 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:46581 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756656AbZCBIJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 03:09:16 -0500
Subject: Re: [patch 2/2] slqb: x86 cleanup
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20090302065247.GB1257@wotan.suse.de>
References: <20090302064735.GA1257@wotan.suse.de>
	 <20090302065247.GB1257@wotan.suse.de>
Date: Mon, 02 Mar 2009 10:09:13 +0200
Message-Id: <1235981353.18284.19.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-02 at 07:52 +0100, Nick Piggin wrote:
> My virt_to_page_fast speedup for x86-64 snuck in to the slqb patch, where it
> does not belong. Oops.
> 
> Signed-off-by: Nick Piggin <npiggin@suse.de>

Applied, thanks!

