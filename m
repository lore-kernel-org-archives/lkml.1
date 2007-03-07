Return-Path: <linux-kernel-owner+w=401wt.eu-S1422670AbXCGJhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422670AbXCGJhn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 04:37:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422675AbXCGJhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 04:37:43 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:38259 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422670AbXCGJhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 04:37:42 -0500
Date: Wed, 7 Mar 2007 09:37:41 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH 2/6] UDF cleanup and fixes
Message-ID: <20070307093741.GB14863@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
	akpm@osdl.org
References: <20070306164447.GC3661@duck.suse.cz> <20070306164659.GE3661@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070306164659.GE3661@duck.suse.cz>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2007 at 05:46:59PM +0100, Jan Kara wrote:
> Introduce a structure extent_position to store a position of an extent and
> the corresponding buffer_head in one place.

Looks good.

