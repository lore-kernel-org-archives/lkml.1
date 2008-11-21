Return-Path: <linux-kernel-owner+w=401wt.eu-S1755323AbYKUNiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbYKUNiz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 08:38:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbYKUNiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 08:38:46 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:52478 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbYKUNip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 08:38:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=OCWpRbOtHVMrFpk3hv70lmfpU1uVRXRx7h4xPa7CgWUZ7y+hUFc3+h7+J7g2+QAWaU
         zTd37r1+TEDBgKV4FzeyLW5nt4YADAl6jNpRRlmKIHfzbUpyVYY8fOuvx7+3v05T1QmX
         5go8oljFj4lsfrujjbI1Q/k3EiI3avQ65ESIg=
Message-ID: <7c86c4470811210538i5e6958e1p2c31effa762f5914@mail.gmail.com>
Date: Fri, 21 Nov 2008 14:38:43 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Subject: Re: debugctl msr
Cc: "Markus Metzger" <markus.t.metzger@googlemail.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77E08F115BC@irsmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7c86c4470810300753v7d377092qbcd266178d8e7338@mail.gmail.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E08F10AAA@irsmsx504.ger.corp.intel.com>
	 <7c86c4470811190459y5996f51bp24ab38c9e856c2eb@mail.gmail.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E08F10CB1@irsmsx504.ger.corp.intel.com>
	 <7c86c4470811190913u743706abgafff3b0f0e3559ec@mail.gmail.com>
	 <1227119245.6025.12.camel@raistlin>
	 <7c86c4470811191120i63b70970s3e24af5c962ea538@mail.gmail.com>
	 <1227133570.6104.10.camel@raistlin>
	 <7c86c4470811201319x2eb93d41vbdd8ce480a797fab@mail.gmail.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E08F115BC@irsmsx504.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markus,

On Fri, Nov 21, 2008 at 9:22 AM, Metzger, Markus T
<markus.t.metzger@intel.com> wrote:
> I also added the interrupt threshold to the parameters of ds_request().
> It will be fix for one tracing session, if that's OK with you.
>
I still need a call to query the threshold.
