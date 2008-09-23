Return-Path: <linux-kernel-owner+w=401wt.eu-S1754789AbYIWGCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbYIWGCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 02:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbYIWGCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 02:02:03 -0400
Received: from tundra.namei.org ([65.99.196.166]:33087 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774AbYIWGCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 02:02:00 -0400
Date: Tue, 23 Sep 2008 16:01:28 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: akpm@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CRED: Delete alloc_creds() as it's not used
In-Reply-To: <20080922231005.2472.65288.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.1.10.0809231600270.25628@tundra.namei.org>
References: <20080922231005.2472.65288.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2008, David Howells wrote:

> Delete alloc_creds() as it's not used.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next-creds-subsys

(and not #next-creds, which is supposed to be dead).


- James
-- 
James Morris
<jmorris@namei.org>
