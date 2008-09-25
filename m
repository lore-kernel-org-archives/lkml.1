Return-Path: <linux-kernel-owner+w=401wt.eu-S1755302AbYIYV4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302AbYIYV4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 17:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbYIYV4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 17:56:10 -0400
Received: from tundra.namei.org ([65.99.196.166]:51915 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848AbYIYV4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 17:56:09 -0400
Date: Fri, 26 Sep 2008 07:56:05 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: marc.c.dionne@gmail.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CRED: Use correct task_struct members in cred.h
 comments
In-Reply-To: <20080925140335.12957.38478.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.1.10.0809260754490.14159@tundra.namei.org>
References: <20080925140335.12957.38478.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2008, David Howells wrote:

> From: Marc Dionne <marc.c.dionne@gmail.com>
> 
> Adjust comments in linux/cred.h - use the correct names for the struct cred
> pointers in the task_struct structure.
> 
> Signed-off-by: Marc Dionne <marc.c.dionne@gmail.com>
> Signed-off-by: David Howells <dhowells@redhat.com>

Applied to:
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next-creds-subsys


-- 
James Morris
<jmorris@namei.org>
