Return-Path: <linux-kernel-owner+w=401wt.eu-S1753912AbZIPWMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912AbZIPWMM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751664AbZIPWMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:12:10 -0400
Received: from tundra.namei.org ([65.99.196.166]:56787 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197AbZIPWMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:12:09 -0400
Date: Thu, 17 Sep 2009 08:11:41 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, torvalds@osdl.org, eparis@redhat.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KEYS: Have the garbage collector set its timer for live
 expired keys
In-Reply-To: <32075.1253114214@redhat.com>
Message-ID: <alpine.LRH.2.00.0909170810460.4844@tundra.namei.org>
References: <20090916150556.GA23523@elte.hu> <20090916145414.31860.16602.stgit@warthog.procyon.org.uk> <32075.1253114214@redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Sep 2009, David Howells wrote:

> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > Is this in response to my bugreport? (If yes then the changelog is quite 
> > vague about the circumstances of the bug, its effects, which tools were 
> > used to find it, etc. etc.)
> 
> No.

Is it a bugfix, or an enhancement?

-- 
James Morris
<jmorris@namei.org>
