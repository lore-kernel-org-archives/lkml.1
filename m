Return-Path: <linux-kernel-owner+w=401wt.eu-S1755256AbYIOR07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbYIOR07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 13:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbYIOR0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 13:26:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59374 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbYIOR0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 13:26:51 -0400
Date: Mon, 15 Sep 2008 13:26:48 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       samr <sam@ravnborg.org>, Roland McGrath <roland@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] kernel-doc: allow structs whose members are all private
Message-ID: <20080915172648.GA2856@infradead.org>
References: <20080915100229.cf32f74e.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080915100229.cf32f74e.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2008 at 10:02:29AM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix kernel-doc to handle structs whose members are all private;
> otherwise invalid XML is generated:

What's supposed to be a private member? 

