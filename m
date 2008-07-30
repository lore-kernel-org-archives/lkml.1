Return-Path: <linux-kernel-owner+w=401wt.eu-S1762423AbYG3OX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762423AbYG3OX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 10:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758408AbYG3OXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 10:23:21 -0400
Received: from outbound-mail-155.bluehost.com ([67.222.39.35]:38078 "HELO
	outbound-mail-155.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754277AbYG3OXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 10:23:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=DoUbq8v6ibMaT0mvHH7PFA7o3W2rms52h1hog5tdynOQW6DK1E0SNnZCQuAy6J/3LqIXzE94f5NCU0CNoUPK6D//fHvGT3QgEANFR3xL56kNLpJ7ZBvaDSn3sSZdA2aG;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch 00/31] pci_ids.h, kernel 2.6.27-rc1, sort DEVICE_IDs within VENDOR_IDs
Date: Wed, 30 Jul 2008 07:23:14 -0700
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, mcs6502@gmail.com,
       linux-kernel@vger.kernel.org
References: <E1KO7OU-0007BT-Ff@wraith.cs.uow.edu.au> <20080730034255.ac5aa6c2.akpm@linux-foundation.org> <20080730113538.2a2422ba@lxorguk.ukuu.org.uk>
In-Reply-To: <20080730113538.2a2422ba@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807300723.14970.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 30, 2008 3:35 am Alan Cox wrote:
> > a) slam it into mainline immediately or
> >
> > b) ask you to regenerate it during the 2.6.28 merge window or
> >
> > c) forget the whole idea.
>
> I vote for (a). At some point it needs doing and the sooner we do it the
> better. I've scanned all the diffs and they appear correct. As we've seen
> from the MAINTAINERS file once you get errors they spread rapidly.
>
> Acked-by: Alan Cox <alan@redhat.com>

Yeah, let's just get it over with.

Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>

Thanks,
Jesse
