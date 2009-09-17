Return-Path: <linux-kernel-owner+w=401wt.eu-S1755984AbZIQGsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbZIQGsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 02:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754715AbZIQGsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 02:48:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754334AbZIQGsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 02:48:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LRH.2.00.0909170810460.4844@tundra.namei.org>
References: <alpine.LRH.2.00.0909170810460.4844@tundra.namei.org> <20090916150556.GA23523@elte.hu> <20090916145414.31860.16602.stgit@warthog.procyon.org.uk> <32075.1253114214@redhat.com>
To: James Morris <jmorris@namei.org>
Cc: dhowells@redhat.com, Ingo Molnar <mingo@elte.hu>, torvalds@osdl.org,
       eparis@redhat.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KEYS: Have the garbage collector set its timer for live expired keys
Date: Thu, 17 Sep 2009 07:47:22 +0100
Message-ID: <3804.1253170042@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris <jmorris@namei.org> wrote:

> Is it a bugfix, or an enhancement?

Bug fix.

David
