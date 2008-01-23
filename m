Return-Path: <linux-kernel-owner+w=401wt.eu-S1753678AbYAWTsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678AbYAWTsb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 14:48:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbYAWTsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 14:48:24 -0500
Received: from verein.lst.de ([213.95.11.210]:36026 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbYAWTsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 14:48:23 -0500
Date: Wed, 23 Jan 2008 20:41:28 +0100
From: Christoph Hellwig <hch@lst.de>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Al Viro <viro@ftp.linux.org.uk>, David Howells <dhowells@redhat.com>,
       William H Taber <wtaber@us.ibm.com>,
       William Cesar de Oliveira <owilliam@br.ibm.com>,
       Richard Kissel <rkissel@us.ibm.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] Fix procfs task exe symlink
Message-ID: <20080123194128.GA2571@lst.de>
References: <1201112977.5443.29.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201112977.5443.29.camel@localhost.localdomain>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2008 at 10:29:37AM -0800, Matt Helsley wrote:
> For executables on the stackable MVFS filesystem the current procfs methods for
> implementing a task's exe symlink do not point to the correct file and
> applications relying on the symlink fail (see the java example below).

Dou you have a pointer to the source code for that filesystem?

