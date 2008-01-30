Return-Path: <linux-kernel-owner+w=401wt.eu-S1762968AbYA3Vym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762968AbYA3Vym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 16:54:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756915AbYA3Vy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 16:54:28 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:44618 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762676AbYA3Vy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 16:54:26 -0500
From: Konrad Rzeszutek <konrad@darnok.org>
To: Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH] Add iSCSI iBFT support (v0.4.5)
Date: Wed, 30 Jan 2008 16:47:26 -0500
User-Agent: KMail/1.9.6
Cc: "H. Peter Anvin" <hpa@zytor.com>, Doug Maxey <dwm@enoyolf.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       greg@kroah.com, darnok@68k.org, konradr@redhat.com,
       konradr@linux.vnet.ibm.com, randy.dunlap@oracle.com, lenb@kernel.org,
       mike.anderson@us.ibm.com, dwm@austin.ibm.com, arjan@infradead.org,
       michaelc@cs.wisc.edu, Andy Whitcroft <apw@shadowen.org>
References: <20080125220629.GA25325@andromeda.dapyr.net> <200801281547.00865.konrad@darnok.org> <479E455F.7010706@redhat.com>
In-Reply-To: <479E455F.7010706@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801301647.28570.konrad@darnok.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> That being said, I don't think there's any reason to expect the table to
> show up on anything but i386 and x86_64, and maybe ia64.

I've posted a new patch (http://lkml.org/lkml/2008/1/30/531) that includes 
that dependency in the Kconfig (i386, x86_64, ia64)



