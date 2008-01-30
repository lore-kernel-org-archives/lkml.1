Return-Path: <linux-kernel-owner+w=401wt.eu-S1755121AbYA3Ii0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121AbYA3Ii0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 03:38:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756302AbYA3IiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 03:38:11 -0500
Received: from wx-out-0506.google.com ([66.249.82.226]:17635 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756292AbYA3IiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 03:38:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cgFM3/y6zoLMOpuLKQXOnS+oJnHRiWtTj1vRORVCnDFksiclwrVTJlkJOa3Pnu+IKn2Jllu+8fOgvpp4tMdBb11GQCSIesRRbAE6WPVJI8HnsyN+B27ELxDFa5Ir6DeVBT0GgPOSI4QVmKY5ZgwCn08/AFm7LW+U5WeTrCAlqWo=
Message-ID: <e2e108260801300038q10132aafs1dbc6e5400fc47bb@mail.gmail.com>
Date: Wed, 30 Jan 2008 09:38:04 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Cc: rdreier@cisco.com, James.Bottomley@hansenpartnership.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org, vst@vlnb.net,
       linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080130083239E.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
	 <1201639331.3069.58.camel@localhost.localdomain>
	 <adazluoe2t3.fsf@cisco.com>
	 <20080130083239E.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 30, 2008 12:32 AM, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
>
> iSER has parameters to limit the maximum size of RDMA (it needs to
> repeat RDMA with a poor configuration)?

Please specify which parameters you are referring to. As you know I
had already repeated my tests with ridiculously high values for the
following iSER parameters: FirstBurstLength, MaxBurstLength and
MaxRecvDataSegmentLength (16 MB, which is more than the 1 MB block
size specified to dd).

Bart Van Assche.
