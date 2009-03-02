Return-Path: <linux-kernel-owner+w=401wt.eu-S1757197AbZCBJzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197AbZCBJzE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 04:55:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758735AbZCBJyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 04:54:39 -0500
Received: from crmm.lgl.lu ([158.64.72.228]:57584 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757573AbZCBJyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 04:54:38 -0500
Message-ID: <49ABACC4.2020603@knaff.lu>
Date: Mon, 02 Mar 2009 10:54:12 +0100
From: Alain Knaff <alain@knaff.lu>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>, Jan Engelhardt <jengelh@medozas.de>,
       the arch/x86 maintainers <x86@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: tip: bzip2/lzma now in tip:x86/setup-lzma
References: <49614491.7020903@knaff.lu> <49614D1F.8020900@zytor.com> <alpine.LSU.2.00.0902172202230.5620@fbirervta.pbzchgretzou.qr> <499B267E.2090509@zytor.com> <20090217220825.GA24337@elte.hu> <20090217233708.GA10756@elte.hu> <499B5BCA.8000905@zytor.com> <499BBD62.5090506@knaff.lu> <499DBCDD.90806@knaff.lu> <49AA8AA9.7080200@knaff.lu> <20090302095301.GH20897@elte.hu>
In-Reply-To: <20090302095301.GH20897@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Alain Knaff <alain@knaff.lu> wrote:
>> Any comments about this? Ingo, does it solve the issue with 
>> randconfig?
> 
> I've reactivated tip:x86/setup-lzma in tip:master and started 
> testing it with the problem .config, on the problem test-system. 
> The bug is most likely fixed, so consider it queued up for 
> 2.6.30 unless i report some new issue.
> 
> Thanks,
> 
> 	Ingo

Thanks. I'm glad we finally made it :-)

Regards,

Alain

