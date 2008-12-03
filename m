Return-Path: <linux-kernel-owner+w=401wt.eu-S1754799AbYLCSXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbYLCSXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 13:23:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbYLCSXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 13:23:04 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35182 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbYLCSXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 13:23:01 -0500
Date: Wed, 3 Dec 2008 13:23:00 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 2/6] integrity: Linux Integrity Module(LIM)
Message-ID: <20081203182300.GA31203@infradead.org>
References: <cover.1228253618.git.zohar@linux.vnet.ibm.com> <a9835f10cb3efd9951fa6e9fcc2e29f528ba625b.1228253618.git.zohar@linux.vnet.ibm.com> <20081203123021.GA30035@infradead.org> <1228328323.2821.30.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228328323.2821.30.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2008 at 01:18:43PM -0500, Mimi Zohar wrote:
> IMA originally supported measurement and attestation only for file data.
> Templates provide an abstraction to add different types of integrity
> messages to the TPM based measurement list. Each type of integrity code
> knows how to format/display its own messages, while the TPM measurement
> list code remains generic.

I have a bit of a problem parsing the above, and it certainly doesn't
look like a justification for keeping all that unused code around.

