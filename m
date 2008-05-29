Return-Path: <linux-kernel-owner+w=401wt.eu-S1755581AbYE2TmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581AbYE2TmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 15:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbYE2TmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 15:42:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878AbYE2TmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 15:42:10 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080529192439.GB32180@cs181133002.pp.htv.fi>
References: <20080529192439.GB32180@cs181133002.pp.htv.fi> <20080529181726.5396.79336.stgit@warthog.procyon.org.uk> <20080529181741.5396.66279.stgit@warthog.procyon.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] Werror: Hide warnings on static module device tables
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Thu, 29 May 2008 20:41:47 +0100
Message-ID: <3009.1212090107@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@kernel.org> wrote:

> Isn't the warning often a reminder that a driver should be updated to 
> use pci_register_driver() etc. ?

If it is, it's not mentioned in Documentation/ or at the definition of
MODULE_DEVICE_TABLE.

Also, does that apply to the isapnp driver?

David
