Return-Path: <linux-kernel-owner+w=401wt.eu-S1758387AbZIQNBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758387AbZIQNBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 09:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755416AbZIQNB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 09:01:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664AbZIQNB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 09:01:29 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1253119289-19261-1-git-send-email-tabbott@ksplice.com>
References: <1253119289-19261-1-git-send-email-tabbott@ksplice.com>
To: Tim Abbott <tabbott@ksplice.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH v2 0/2] Linker script cleanup patches for frv
Date: Thu, 17 Sep 2009 14:01:21 +0100
Message-ID: <8410.1253192481@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Abbott <tabbott@ksplice.com> wrote:

> This is an updated version of the patch series I sent in late July
> cleaning up the frv architecture's linker scripts.  The only change is
> that it is rebased on top of Linus's current master.
> 
> This cross-architecture linker script cleanup project is in
> preparation for adding support for building the kernel with
> -ffunction-sections -fdata-sections, which is a prerequisite for
> Ksplice.

Acked-by: David Howells <dhowells@redhat.com>

for both patches
