Return-Path: <linux-kernel-owner+w=401wt.eu-S1762978AbYB0XNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762978AbYB0XNu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 18:13:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762271AbYB0XKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 18:10:45 -0500
Received: from relay1.sgi.com ([192.48.171.29]:49168 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762254AbYB0XKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 18:10:44 -0500
Date: Wed, 27 Feb 2008 15:10:43 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Howells <dhowells@redhat.com>
cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MM: Fix macro argument substitution in PageHead() and
 PageTail()
In-Reply-To: <20080221161245.12991.32410.stgit@warthog.procyon.org.uk>
Message-ID: <Pine.LNX.4.64.0802271510270.13186@schroedinger.engr.sgi.com>
References: <20080221161245.12991.32410.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Feb 2008, David Howells wrote:

> Fix macro argument substitution in PageHead() and PageTail() - 'page' should
> have brackets surrounding it (commit 6d7779538f765963ced45a3fa4bed7ba8d2c277d).

Acked-by: Christoph Lameter <clameter@sgi.com>

