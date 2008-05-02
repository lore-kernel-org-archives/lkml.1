Return-Path: <linux-kernel-owner+w=401wt.eu-S933937AbYEBCJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933937AbYEBCJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 22:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755554AbYEBCJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 22:09:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754253AbYEBCJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 22:09:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1209683136.24729.207.camel@brick>
References: <1209683136.24729.207.camel@brick>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/9] frv: gdb-stub.c use the common ascii hex helpers
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Fri, 02 May 2008 03:09:00 +0100
Message-ID: <11442.1209694140@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison <harvey.harrison@gmail.com> wrote:

>  arch/frv/kernel/gdb-stub.c |  163 ++++++++++++++++++++------------------------
>  1 files changed, 73 insertions(+), 90 deletions(-)

Can you send me the base patch this is built on?  These functions you're using
don't seem to be upstream.

David
