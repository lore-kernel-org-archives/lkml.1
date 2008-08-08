Return-Path: <linux-kernel-owner+w=401wt.eu-S1759865AbYHHXQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759865AbYHHXQY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 19:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764932AbYHHXPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 19:15:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59614 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760467AbYHHXPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 19:15:53 -0400
Date: Fri, 8 Aug 2008 19:15:52 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, sailer@watson.ibm.com, zohar@us.ibm.com
Subject: Re: [PATCH 2/4] integrity: special fs magic
Message-ID: <20080808231552.GA21616@infradead.org>
References: <20080808184349.999902616@linux.vnet.ibm.com> <1218221742.4444.12.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218221742.4444.12.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 02:55:42PM -0400, Mimi Zohar wrote:
>     - Move special fs magic number definitions to magic.h
>     - Add magic.h include

Moving them is fine, using them for anything however is not.

