Return-Path: <linux-kernel-owner+w=401wt.eu-S933075AbXCNVih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933075AbXCNVih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 17:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbXCNVih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 17:38:37 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:31340 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbXCNVig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 17:38:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cobe15RhgwInyFHfqCpVATZDXCjdto3B8MoXmsJFC9nktSbTP8jL2zuK3ifdUeugG5O5QZI9B+/78wn2MlbwKEQCl/qP+lvNBnzIMPs2MEjCTj/bbivxwyGrBdiLAvwfabdlV5RRi9YdKUAmI6VNQ02qH5fWrE2BKHQxI5ybKSM=
Message-ID: <acd2a5930703141438tb77394elff8f9f65c698242e@mail.gmail.com>
Date: Thu, 15 Mar 2007 00:38:35 +0300
From: "Vitaly Wool" <vitalywool@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] 8250: make probing for TXEN bug a config option
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070213224643.14d27cd3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20061226194317.3fd3ec14.vitalywool@gmail.com>
	 <20070213224643.14d27cd3.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/14/07, Andrew Morton <akpm@linux-foundation.org> wrote:

> I think this should be a module option/boot parameter, not a config-time
> option.

NM, the recent changes in 8250 driver eliminated the need for this patch :)

Vitaly
