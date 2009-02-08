Return-Path: <linux-kernel-owner+w=401wt.eu-S1753899AbZBHWj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbZBHWj0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 17:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbZBHWjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 17:39:17 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:19098 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbZBHWjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 17:39:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=U+fQ6wc9oN/vH80I6jkG7jGAhSQxdv6dgtjEf2wQ3vxnvLJM8UXTSnwIQRPJHbViLB
         6cVQenQiJMh2M6bxJbUgD1YoqzWqFcuHHo2TJluesONhHnC4308G04QiE7WQSBW/483R
         jB+9NmBe/CohflFv4bwlwaa+D3bS1Td2ZgSlk=
Subject: Re: XFS kernel BUG at fs/buffer.c:470! with 2.6.28.4
From: Alessandro Bono <alessandro.bono@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-xfs <linux-xfs@oss.sgi.com>
In-Reply-To: <20090208222859.GA2532@infradead.org>
References: <1234011974.7435.11.camel@champagne.cantina>
	 <20090208222859.GA2532@infradead.org>
Content-Type: text/plain
Date: Sun, 08 Feb 2009 23:39:12 +0100
Message-Id: <1234132752.12370.0.camel@champagne.cantina>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-02-08 at 17:28 -0500, Christoph Hellwig wrote:
> On Sat, Feb 07, 2009 at 02:06:13PM +0100, Alessandro Bono wrote:
> > Feb  7 12:43:12 champagne kernel: [ 5828.167041] ------------[ cut
> > here ]------------
> > Feb  7 12:43:12 champagne kernel: [ 5828.167048] kernel BUG at
> > fs/buffer.c:470!
> 
> Per
> http://git.kernel.org/?p=linux/kernel/git/hpa/linux-2.6-allstable.git;a=blob;f=fs/buffer.c;h=665d446b25bc034241ef54c3c6b1d239c0ccf0f9;hb=d5b562330ec766292a3ac54ae5e0673610bd5b3d
> 
> line 470 in fs/buffer.c of 2.6.28.4 has a comment and no actual code.
> 
> What additional patches do you have applied?
> 

vanilla kernel
no additional patches at all

-- 
---
Cordiali Saluti
Alessandro Bono

