Return-Path: <linux-kernel-owner+w=401wt.eu-S1755141AbZBRTyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbZBRTyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 14:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbZBRTyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 14:54:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43615 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbZBRTyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 14:54:03 -0500
Message-ID: <499C674E.8010903@zytor.com>
Date: Wed, 18 Feb 2009 11:53:50 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: Alain Knaff <alain@knaff.lu>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: tip: bzip2/lzma now in tip:x86/setup-lzma
References: <200901042146.n04LkHgP005837@hitchhiker.hitchhiker.org.lu.hitchhiker.org.lu> <4961415C.1050708@zytor.com> <49614243.70102@knaff.lu> <496142E4.8040308@zytor.com> <49614491.7020903@knaff.lu> <49614D1F.8020900@zytor.com> <alpine.LSU.2.00.0902172202230.5620@fbirervta.pbzchgretzou.qr> <499B267E.2090509@zytor.com> <20090217220825.GA24337@elte.hu> <20090217233708.GA10756@elte.hu> <499B5BCA.8000905@zytor.com> <499BBD62.5090506@knaff.lu> <alpine.LSU.2.00.0902181012130.5116@fbirervta.pbzchgretzou.qr> <499BD795.6050602@knaff.lu> <alpine.LSU.2.00.0902181127310.30241@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LSU.2.00.0902181127310.30241@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> Even if it is true in general, I would not remove CONFIG_INITRAMFS_SOURCE
> and attached logic, unless it were a major burden on the maintainers.
> (I am not to quantify whether it is such a burden, or is not.)

Removing CONFIG_INITRAMFS_SOURCE et al is not an option.  It's widely 
used.  Nor is it a technical issue.

	-hpa
