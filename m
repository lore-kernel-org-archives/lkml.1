Return-Path: <linux-kernel-owner+w=401wt.eu-S1752522AbZGaM27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbZGaM27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 08:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbZGaM26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 08:28:58 -0400
Received: from cpsmtpm-eml105.kpnxchange.com ([195.121.3.9]:49527 "EHLO
	CPSMTPM-EML105.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751953AbZGaM26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 08:28:58 -0400
From: Frans Pop <elendil@planet.nl>
To: David Howells <dhowells@redhat.com>
Subject: Re: RomFS: enless loop during make oldconfig from 2.6.24 -> 2.6.31-rc4 (parisc)
Date: Fri, 31 Jul 2009 14:28:55 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       David Woodhouse <David.Woodhouse@intel.com>
References: <200907311227.20132.elendil@planet.nl> <4977.1249041840@redhat.com>
In-Reply-To: <4977.1249041840@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907311428.56932.elendil@planet.nl>
X-OriginalArrivalTime: 31 Jul 2009 12:28:57.0547 (UTC) FILETIME=[79AE01B0:01CA11DA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 July 2009, David Howells wrote:
> Frans Pop <elendil@planet.nl> wrote:
> > # Linux kernel version: 2.6.24-rc3test
>
> I presume this is not the version of the kernel you're using.  This
> RomFS feature was not upstream back then.  What version are you using?

As the Subject says, the make oldconfig was for 2.6.31-rc4 :-)

$ git describe master
v2.6.31-rc4-294-gf5886c7

Cheers,
FJP
