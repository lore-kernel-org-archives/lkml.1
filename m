Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab0BOGtU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 01:49:20 -0500
Received: from mail-yx0-f196.google.com ([209.85.210.196]:48333 "EHLO
	mail-yx0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab0BOGtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 01:49:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=uDFf7vaFszDW/tCjTdc51WCVWn9juFa5VzLi6ZryZRtDpHxOhgLv87kExhJWdHGnOV
         kAMwXW8m8RDNxxxYDSfpZjQzaKIEVea/cO8RYei25FRAQpL1F8jzHrlrpgYfqXsJW/+G
         cb0KIPB6FqDWLnNkZaLU9MDfLMqZcZsZIM8Zg=
Message-ID: <4B78EE6A.3010207@lwfinger.net>
Date: Mon, 15 Feb 2010 00:49:14 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100111 SUSE/3.0.1-1.1 Thunderbird/3.0.1
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, mb@bu3sch.de,
       davem@davemloft.net, stefano.brivio@polimi.it,
       akpm@linux-foundation.org
Subject: Re: [PATCH -mm] ssb: open-code dma_alloc_coherent
References: <20100215142111R.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100215142111R.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2010 11:21 PM, FUJITA Tomonori wrote:
> This patch is against -mm since it depends on the DMA API changes in
> -mm.

Are the patches that implement these DMA API changes available for testing? I
don't keep an -mm tree.

Larry

