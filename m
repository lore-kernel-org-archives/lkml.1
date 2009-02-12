Return-Path: <linux-kernel-owner+w=401wt.eu-S1760416AbZBLUVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760416AbZBLUVH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 15:21:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758315AbZBLUUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 15:20:53 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:1072 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757966AbZBLUUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 15:20:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Joz+d4oL6IfNDCrCdNQ63/M+f0XrhUrI32yYsesktgLb4KYsE2zOuxr45W0R/uJlTo
         4w/6XQYOhd/n5yyq7ifo1IDcnWVs2cjyAXFmDii1PlrrLrjbMeosUWDnERetfANZDPMx
         U8/p7aQeyFDsbMcREGQzHZ8AAz4i8KjIXYW6I=
Subject: Re: get/put unaligned helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
In-Reply-To: <4993E2CA.1070408@panasas.com>
References: <20090211143521.GA18866@lst.de> <1234367339.5481.3.camel@brick>
	 <4993E2CA.1070408@panasas.com>
Content-Type: text/plain
Date: Thu, 12 Feb 2009 12:20:50 -0800
Message-Id: <1234470050.5566.23.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-12 at 10:50 +0200, Boaz Harrosh wrote:
> Harvey Harrison wrote:

> Speaking of which. When all this is done do you intend to also export
> the unaligned.h headers to user-mode just like the aligned Endian helpers?
> 

No.

Harvey

