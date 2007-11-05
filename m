Return-Path: <linux-kernel-owner+w=401wt.eu-S1755827AbXKERZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbXKERZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 12:25:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760517AbXKERSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 12:18:43 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56144 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757698AbXKERSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 12:18:42 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20071105170628.GZ12045@stusta.de>
References: <20071105170628.GZ12045@stusta.de>
To: Adrian Bunk <bunk@kernel.org>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] move frv docs one level up
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Mon, 05 Nov 2007 17:18:32 +0000
Message-ID: <30293.1194283112@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@kernel.org> wrote:

> Move the frv directory one level up since frv is the name of the 
> architecture in the Linux kernel.

This patch is not sufficient.  It does not change all the references in the
code.

David
