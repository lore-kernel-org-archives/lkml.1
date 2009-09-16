Return-Path: <linux-kernel-owner+w=401wt.eu-S1759249AbZIPPSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759249AbZIPPSl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 11:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759210AbZIPPSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 11:18:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758976AbZIPPSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 11:18:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090916150556.GA23523@elte.hu>
References: <20090916150556.GA23523@elte.hu> <20090916145414.31860.16602.stgit@warthog.procyon.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: dhowells@redhat.com, torvalds@osdl.org, jmorris@namei.org,
       eparis@redhat.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KEYS: Have the garbage collector set its timer for live expired keys
Date: Wed, 16 Sep 2009 16:16:54 +0100
Message-ID: <32075.1253114214@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> wrote:

> Is this in response to my bugreport? (If yes then the changelog is quite 
> vague about the circumstances of the bug, its effects, which tools were 
> used to find it, etc. etc.)

No.

David
