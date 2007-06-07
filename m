Return-Path: <linux-kernel-owner+w=401wt.eu-S935481AbXFGTiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935481AbXFGTiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 15:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964992AbXFGTh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 15:37:56 -0400
Received: from wx-out-0506.google.com ([66.249.82.233]:30482 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964926AbXFGThy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 15:37:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=WhWdX7XPTlms+2o9ZQpxzEn2CiOsoJSJCNz5PdfXSRfJiM+R4/Rf24QC2DsrdSRXU/lSxOrVXOp/zP8uAzaNb6uG+pVrd3RgLJ8ywvhV/mDLXYoUZ3q8MRFNKXlkvmcLxC4JANdWIWTLndihU6F4Crl8zeZm3oZ8Rvjc25YskKY=
Date: Thu, 7 Jun 2007 15:37:51 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, bluesmoke-devel@lists.sourceforge.net
Subject: Re: 2.6.22-rc4-mm2
Message-ID: <20070607193751.GA8204@nineveh.local>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, bluesmoke-devel@lists.sourceforge.net
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: jfannin@gmail.com (Joseph Fannin)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 10:03:13PM -0700, Andrew Morton wrote:
>
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm2/

    I don't think this was intentional: 

    [   29.873254] edac_stub: module license 'unspecified' taints kernel.

--
Joseph Fannin
jfannin@gmail.com || jhf@columbus.rr.com

