Return-Path: <linux-kernel-owner+w=401wt.eu-S936305AbYD1SeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936305AbYD1SeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 14:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966177AbYD1Sam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 14:30:42 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:55360 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966134AbYD1Saj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 14:30:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=rP4OWbr2KHAJWmtDIHWttwdhLfE+rHRRCOjVOTP+o1S0yFXTSkHkExfmRKBpPCNJ4yhEbCN28vBRQ3X9jqigmcsHk1w9kNv0IWSOkhxfMHM0oP0uf2ANk1Cqg9IUjy5vvGWKlrNwAMHGl+gRe2oUHTm0p3INWYwthk+ihY2qDLg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] more icside breakage (from next ide merge)
Date: Mon, 28 Apr 2008 20:45:20 +0200
User-Agent: KMail/1.9.9
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       sfr@canb.auug.org.au
References: <E1JqMOb-0004lx-VW@ZenIV.linux.org.uk>
In-Reply-To: <E1JqMOb-0004lx-VW@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804282045.20304.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 April 2008, Al Viro wrote:
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Thanks for fixing this and q40ide.
