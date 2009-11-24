Return-Path: <linux-kernel-owner+w=401wt.eu-S1757225AbZKXAJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225AbZKXAJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 19:09:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbZKXAJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 19:09:17 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:38099 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203AbZKXAJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 19:09:16 -0500
Date: Tue, 24 Nov 2009 00:09:29 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-mips@linux-mips.org
Subject: Re: linux-next: failed to fetch the mips tree
Message-ID: <20091124000929.GA7223@linux-mips.org>
References: <20091124105303.512479aa.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091124105303.512479aa.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 10:53:03AM +1100, Stephen Rothwell wrote:

> git.linux-mips.org[0: 78.24.191.183]: errno=Connection refused
> fatal: unable to connect a socket (Connection refused)

Thanks.  I upgraded the machine from Fedora 10 to Fedora 12 and the
removal of the git "dash-commands" resulted in this failure.  Fixed.

> I will use the version from next-20091123 for today.

No problem; all changes can wait another day.

  Ralf
