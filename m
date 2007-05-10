Return-Path: <linux-kernel-owner+w=401wt.eu-S1758517AbXEJGyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517AbXEJGyG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 02:54:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963AbXEJGx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 02:53:56 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58418 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274AbXEJGxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 02:53:55 -0400
Date: Thu, 10 May 2007 07:53:48 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [patch 10/10] Port of blktrace to the Linux Kernel Markers.
Message-ID: <20070510065348.GA8019@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20070510015555.973107048@polymtl.ca> <20070510020918.085866258@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510020918.085866258@polymtl.ca>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 09:56:05PM -0400, Mathieu Desnoyers wrote:
> Here is a proof of concept patch, for demonstration purpose, of moving
> blktrace to the markers.

Please get an ACK from Jens as blktrace is his code.

