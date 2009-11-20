Return-Path: <linux-kernel-owner+w=401wt.eu-S1753896AbZKTPBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbZKTPBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 10:01:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbZKTPBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 10:01:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558AbZKTPBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 10:01:40 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20091117141314.0238a49b.akpm@linux-foundation.org>
References: <20091117141314.0238a49b.akpm@linux-foundation.org> <1255706463.15182.84.camel@dhcp231-106.rdu.redhat.com> <7e0fb38c0910160801o50346a5cm763d79cab98272a5@mail.gmail.com> <1255516134-4838-1-git-send-email-graff.yang@gmail.com> <18475.1255529305@redhat.com> <6207.1255706090@redhat.com> <23382.1255707790@redhat.com> <1255708529.15182.95.camel@dhcp231-106.rdu.redhat.com> 
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, Eric Paris <eparis@redhat.com>, graff.yang@gmail.com,
       linux-kernel@vger.kernel.org, gyang@blackfin.uclinux.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Graff Yang <graf.yang@analog.com>,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] mm/nommu.c: Fix improperly call of security API in mmap
Date: Fri, 20 Nov 2009 15:00:09 +0000
Message-ID: <16299.1258729209@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> So what's the status of this issue now?  Should I merge the below into
> 2.6.32?

Yes please.

Thanks,
David
