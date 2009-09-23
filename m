Return-Path: <linux-kernel-owner+w=401wt.eu-S1751799AbZIWWTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799AbZIWWTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 18:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751194AbZIWWTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 18:19:33 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:50574 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbZIWWTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 18:19:32 -0400
Date: Wed, 23 Sep 2009 23:20:03 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: Avoid destructive invalidation on partial L2
	cachelines
Message-ID: <20090923221937.GC22516@linux-mips.org>
References: <de70b67245e012ab0c11b520a721989b@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de70b67245e012ab0c11b520a721989b@localhost>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 07:12:45PM -0700, Kevin Cernekee wrote:

> This extends commit a8ca8b64e3fdfec17679cba0ca5ce6e3ffed092d to cover
> the board cache code.
> 
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>

Thanks Kevin, applied.

  Ralf
