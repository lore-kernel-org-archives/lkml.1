Return-Path: <linux-kernel-owner+w=401wt.eu-S1755320AbYFBPKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbYFBPKP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 11:10:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbYFBPJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 11:09:59 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:54524 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbYFBPJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 11:09:58 -0400
Date: Mon, 2 Jun 2008 19:05:17 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, jmorris@namei.org, sds@tycho.nsa.gov,
       eparis@redhat.com, casey@schaufler-ca.com, agruen@suse.de,
       jjohansen@suse.de, penguin-kernel@I-love.SAKURA.ne.jp,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [patch 01/15] security: pass path to inode_create
Message-ID: <20080602150517.GB22400@2ka.mipt.ru>
References: <20080531083052.GH24135@infradead.org> <E1K2uXZ-0001eE-Oi@pomaz-ex.szeredi.hu> <20080602060144.GA11564@infradead.org> <E1K343a-0002dG-C9@pomaz-ex.szeredi.hu> <20080602091341.GA8011@infradead.org> <E1K36PE-0002wZ-0M@pomaz-ex.szeredi.hu> <20080602093630.GA25254@infradead.org> <E1K36ii-0002zj-Gn@pomaz-ex.szeredi.hu> <20080602104203.GA21898@infradead.org> <E1K37hN-00039y-5o@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1K37hN-00039y-5o@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Mon, Jun 02, 2008 at 12:55:33PM +0200, Miklos Szeredi (miklos@szeredi.hu) wrote:
> Oh, I've been told.  But valid technical reason given?  No.

This is a really interesting flame, can you proceed,
we will run for cola and peanuts :)

For the technical reason: in case of stackable/bind, which path should
be checked? Whatever answer is, there will always be another party,
which wants different behaviour.

-- 
	Evgeniy Polyakov
