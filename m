Return-Path: <linux-kernel-owner+w=401wt.eu-S1760132AbZBETKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760132AbZBETKr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:10:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759455AbZBETKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:10:30 -0500
Received: from rn-out-0910.google.com ([64.233.170.186]:32305 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880AbZBETK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:10:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=PZHOUhRCGTxpSBRR0r5NbJAK94/4SKNDuOTRw+yk4fm478AHn0pg4Lb3gQGgAukyHi
         E07E+++ETmHRCSbiYdnFqNCC5nqK2IilWBq5OxENfXwxVZScqTpBY8hD8Q1D6IWMVJz3
         g5XqRvuoK0FfLbM90GM0lfc31pzdqbKOH/+js=
Subject: Re: [PATCH] 9p: fix endian issues [attempt 2]
From: Harvey Harrison <harvey.harrison@gmail.com>
To: ericvh@gmail.com
Cc: v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <1233860727-16884-1-git-send-email-ericvh@gmail.com>
References: <1233860727-16884-1-git-send-email-ericvh@gmail.com>
Content-Type: text/plain
Date: Thu, 05 Feb 2009 11:10:23 -0800
Message-Id: <1233861023.22037.0.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-05 at 13:05 -0600, ericvh@gmail.com wrote:
> From: Eric Van Hensbergen <ericvh@gmail.com>
> 
> When the changes were done to the protocol last release, some endian
> bugs crept in.  This patch fixes those endian problems and has been
> verified to run on 32/64 bit and x86/ppc architectures.
> 
> This version of the patch incorporates the correct annotations
> for endian variables.
> 
> Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>

Looks better to me.

Cheers,

Harvey

