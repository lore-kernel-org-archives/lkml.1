Return-Path: <linux-kernel-owner+w=401wt.eu-S1759286AbYBSPO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759286AbYBSPO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 10:14:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753613AbYBSPOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 10:14:51 -0500
Received: from qb-out-0506.google.com ([72.14.204.233]:52587 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbYBSPOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 10:14:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=F9qCrTzyVmjY3QDlT4ZkMyR/yiejLX5+SjV7Xlq7zMeoDioPkW5vAkDL3+aFQv7qROSxPDHw0s5Tp/Ha9ESGRvnHDLBR3rWKbj/V0Mu/U5P8hoVNyJi89DGjfkkjGTWc2yfcvyH8E0q032AwbLXVzZfwn58qDU1LT/6NSn/DcVs=
Subject: Re: [PATCH 1/3] x86, kvm: add ad_mask static inline
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <47BA95B0.4050806@qumranet.com>
References: <1203361968.5757.42.camel@brick> <47BA95B0.4050806@qumranet.com>
Content-Type: text/plain
Date: Tue, 19 Feb 2008 07:14:57 -0800
Message-Id: <1203434097.7766.6.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-19 at 10:39 +0200, Avi Kivity wrote:
> Harvey Harrison wrote:
> > Replaces open-coded mask calculation in macros.
> >
> >   
> Please regenerate against kvm.git (patch 2 doesn't apply; see 
> http://kvm.qumranet.com/kvmwiki/Code).  Also please copy 
> kvm-devel@lists.sourceforge.net on kvm patches.
> 
> (first patch applied)
> 

Against what branch?

Harvey

