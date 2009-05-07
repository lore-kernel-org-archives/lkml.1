Return-Path: <linux-kernel-owner+w=401wt.eu-S1760142AbZEGIiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760142AbZEGIiu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 04:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755089AbZEGIil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 04:38:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60605 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753887AbZEGIil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 04:38:41 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4A0227AD.9030705@snapgear.com>
References: <4A0227AD.9030705@snapgear.com> <4A00EF23.4050302@snapgear.com> <49FF96A7.5040401@snapgear.com> <3662.1241530861@redhat.com> <30031.1241619079@redhat.com>
To: Greg Ungerer <gerg@snapgear.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: BUG: failure at mm/nommu.c:518/add_nommu_region()
Date: Thu, 07 May 2009 09:38:34 +0100
Message-ID: <17346.1241685514@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Ungerer <gerg@snapgear.com> wrote:

> Yes, that fixes it :-)

Can I add your Acked-by or Tested-by?

David
