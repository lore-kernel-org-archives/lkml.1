Return-Path: <linux-kernel-owner+w=401wt.eu-S1760793AbYDSU45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760793AbYDSU45 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 16:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756664AbYDSU4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 16:56:49 -0400
Received: from rv-out-0708.google.com ([209.85.198.248]:34169 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755808AbYDSU4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 16:56:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bSqQEqrxbIi+esDRGjXsz/8dVNzI26CREcAEe078gDQHXvrul5Zm9Fj4GSYju+l97l/K62aw2vs0A93wtB47/5uxU7l2o1ym5H5L4rehz0Nq8qIacDPLyvr7MrCXRHuvDKyO+ZEUUV0/ZO5XkHwiT06h7RPmJHeOAVCt+Et9VQs=
Message-ID: <86802c440804191356t1519535cje0636414ec9678db@mail.gmail.com>
Date: Sat, 19 Apr 2008 13:56:47 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Mark Salyzyn" <Mark_Salyzyn@adaptec.com>
Subject: Re: aacraid broken in git
Cc: "James.Bottomley@hansenpartnership.com" 
	<James.Bottomley@hansenpartnership.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <3AC1542A-0338-4796-9218-502C4AAD64D2@adaptec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440804181855t615a5616g62d083695ca8ea08@mail.gmail.com>
	 <3AC1542A-0338-4796-9218-502C4AAD64D2@adaptec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 19, 2008 at 5:33 AM, Mark Salyzyn <Mark_Salyzyn@adaptec.com> wrote:
> Why is ACPI disabling the interrupt? Maybe do bisects on the ACPI subsystem
> as well.
probe fail, acpi disable irq routing for it.

YH
