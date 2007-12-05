Return-Path: <linux-kernel-owner+w=401wt.eu-S1754191AbXLEHtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbXLEHtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 02:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbXLEHtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 02:49:07 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:56764 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbXLEHtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 02:49:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=vxZlWFSE7bG+RvBTAvK3JBXimfVR/lOPD8IiskwyheS4QCXRjdmAIjepIiizg5w1cTt3ULa+O7FHGIcbCB3EqTryarlGjSMtAPcq641AsJLhYqknmwfnFcjX+Qj1hUGxCwLGR/tDmXllHyxHSKOl7ipL2u7n88hLkagSDrPkeSQ=
Message-ID: <8499950a0712042349m313455adlc71df0886eb2bba4@mail.gmail.com>
Date: Wed, 5 Dec 2007 07:49:04 +0000
From: "Oleg Verych" <olecom@gmail.com>
To: "Hollis Blanchard" <hollisb@us.ibm.com>
Subject: Re: mkasm-offsets.sh ?
Cc: "Sam Ravnborg" <sam@ravnborg.org>, "Oleg Verych" <olecom@flower.upol.cz>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Rusty Russell" <rusty@ozlabs.au.ibm.com>
In-Reply-To: <1196805584.7475.33.camel@basalt>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1196805584.7475.33.camel@basalt>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 4, 2007 9:59 PM, Hollis Blanchard <hollisb@us.ibm.com> wrote:
> Hi, I found this thread: http://lkml.org/lkml/2007/4/1/237
>
> I guess the complete patch was never finished? I could sure it (for
> pretty much the same reason as lguest).

It was, but untested (widely). The (google) search keyword is
"asm-values", because
there are much more things, than just offsets.
______
