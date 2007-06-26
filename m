Return-Path: <linux-kernel-owner+w=401wt.eu-S1757182AbXFZGJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182AbXFZGJV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 02:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754254AbXFZGJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 02:09:13 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41137 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529AbXFZGJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 02:09:12 -0400
Date: Tue, 26 Jun 2007 07:09:10 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Steve French <smfrench@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, jlayton@redhat.com,
       linux-kernel@vger.kernel.org, linux-cifs-client@lists.samba.org
Subject: Re: [PATCH] CIFS: make cifsd (more)
Message-ID: <20070626060910.GB15134@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Steve French <smfrench@gmail.com>, linux-fsdevel@vger.kernel.org,
	jlayton@redhat.com, linux-kernel@vger.kernel.org,
	linux-cifs-client@lists.samba.org
References: <524f69650706251525g7b17ea02o5fb3e637615fe542@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524f69650706251525g7b17ea02o5fb3e637615fe542@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 05:25:00PM -0500, Steve French wrote:
> Jeff,
> Not seeing any objections to your revised approach (to not allowing
> signals for cifsd kernel thread), I just merged something similar to
> your patch to the cifs-2.6.git tree (also fixed some nearby lines that
> went past 80 columns).

Yes, I still object to it.  I'll come back to the implementation discussion
once I get a little more time.

