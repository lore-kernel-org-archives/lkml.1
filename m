Return-Path: <linux-kernel-owner+w=401wt.eu-S1757227AbZDUVzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227AbZDUVzh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 17:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756317AbZDUVzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 17:55:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46897 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756175AbZDUVzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 17:55:06 -0400
Date: Tue, 21 Apr 2009 22:54:51 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: David Woodhouse <dwmw2@infradead.org>, hooanon05@yahoo.co.jp,
       hch@infradead.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v2] Fix i_mutex handling in nfsd readdir
Message-ID: <20090421215451.GI8633@ZenIV.linux.org.uk>
References: <20090417193233.GM26366@ZenIV.linux.org.uk> <1240006620.19059.41.camel@macbook.infradead.org> <20090417224350.GN26366@ZenIV.linux.org.uk> <20090417225306.GO26366@ZenIV.linux.org.uk> <1240013753.21423.86.camel@macbook.infradead.org> <1240144069.3589.156.camel@macbook.infradead.org> <20090419205154.GA18110@fieldses.org> <20090420195008.GE1823@fieldses.org> <20090421002934.GB8633@ZenIV.linux.org.uk> <20090421211559.GA27411@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090421211559.GA27411@fieldses.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 05:15:59PM -0400, J. Bruce Fields wrote:

> However it makes it there is fine by me; I'll wait for one of you to
> take care of it.

Folded variant is in the mainline.
