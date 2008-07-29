Return-Path: <linux-kernel-owner+w=401wt.eu-S1754807AbYG2RIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbYG2RIl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 13:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbYG2RId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 13:08:33 -0400
Received: from outbound-mail-126.bluehost.com ([67.222.38.26]:56849 "HELO
	outbound-mail-126.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751035AbYG2RIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 13:08:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=JYmh0JE9lLm9TObS8BRkpqSM8z8Vgk+z+Xv+VVbplkOugJd/EHQ3ya14Y4k0s91VEWWA8GYwTE7PqIsP0zgzUPyANs7hhxvTeaLN14P7mEKZgG6LivmMRRLctebizE25;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH]: PCI: GART iommu alignment fixes [v2]
Date: Tue, 29 Jul 2008 10:08:25 -0700
User-Agent: KMail/1.9.9
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, joro@8bytes.org,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
References: <20080723111928.15828.42561.sendpatchset@prarit.bos.redhat.com> <200807281523.35469.jbarnes@virtuousgeek.org> <488F2819.2090303@redhat.com>
In-Reply-To: <488F2819.2090303@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807291008.25583.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 29, 2008 7:24 am Prarit Bhargava wrote:
> > Prarit, what's the latest here?  The v3 patch I have from you doesn't
> > apply to my tree but it looks like a good fix.  Care to send me a new
> > patch against my for-linus branch?
>
> New patch.

Thanks Prarit, I pushed this out to my for-linus branch.

Jesse
