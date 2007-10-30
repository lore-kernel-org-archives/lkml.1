Return-Path: <linux-kernel-owner+w=401wt.eu-S1756178AbXJ3JzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178AbXJ3JzO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 05:55:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318AbXJ3JzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 05:55:00 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45617 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbXJ3Jy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 05:54:59 -0400
Date: Tue, 30 Oct 2007 09:54:51 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Christoph Hellwig <hch@infradead.org>, viro@ftp.linux.org.uk,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/3] VFS: apply coding standards to fs/ioctl.c
Message-ID: <20071030095450.GA22413@infradead.org>
References: <20071028141222.GA29323@infradead.org> <200710281805.l9SI5GoF015442@agora.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710281805.l9SI5GoF015442@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2007 at 02:05:16PM -0400, Erez Zadok wrote:
> 
> Sure.  I assume you mean an internal function to encapsulate the entire case
> statement's code, one for each of the FIO* cases.

Yes.

