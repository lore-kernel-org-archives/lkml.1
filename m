Return-Path: <linux-kernel-owner+w=401wt.eu-S1757709AbZDQXkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757709AbZDQXkK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 19:40:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753495AbZDQXjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 19:39:55 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54157 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbZDQXjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 19:39:55 -0400
Date: Sat, 18 Apr 2009 00:39:52 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: hooanon05@yahoo.co.jp, hch@infradead.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: Q: NFSD readdir in linux-2.6.28
Message-ID: <20090417233952.GQ26366@ZenIV.linux.org.uk>
References: <8036.1237474444@jrobl> <1237475837.16359.106.camel@macbook.infradead.org> <8913.1237476890@jrobl> <1239960739.3428.33.camel@macbook.infradead.org> <20090417193233.GM26366@ZenIV.linux.org.uk> <1240006620.19059.41.camel@macbook.infradead.org> <20090417224350.GN26366@ZenIV.linux.org.uk> <20090417225306.GO26366@ZenIV.linux.org.uk> <1240010612.21423.34.camel@macbook.infradead.org> <20090417233755.GP26366@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090417233755.GP26366@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 18, 2009 at 12:37:55AM +0100, Al Viro wrote:
> 		if (size > 0) /* we'd an error */
				      bailed out early
that is.
