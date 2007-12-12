Return-Path: <linux-kernel-owner+w=401wt.eu-S1760141AbXLLUpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760141AbXLLUpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 15:45:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbXLLUpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 15:45:45 -0500
Received: from web52901.mail.re2.yahoo.com ([206.190.49.11]:34257 "HELO
	web52901.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753452AbXLLUpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 15:45:44 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=Lin+mLPKzkBuQuMhoga/G1vMIZ/2CEcu+hRqZKmUa7Ya4wyTKcYhdywhaTpHlqnfDSN0LEgKL+q330ejZ+9BVZj/6KLiN5TE6GRGJDh6H6Eg+WMikSH4uv7AZavDsyhzOa9CvzOQ2ZzwB6muOICgClYBQS/t+IcHRvNUs+jGfbY=;
X-YMail-OSG: m5MmJhYVM1lTBBiGXzNG1CtjSKVLJzBjiOr8SRAyv9lPSd4v9yjUDClY0WFP6DslAHdgY1pJOkl5Afvmf6TPmSoNrmEYfDgfCqZygiAAcoAa6x76x3DsFGpkhnh7pQ--
Date: Wed, 12 Dec 2007 20:45:42 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [2.6.23.9] hostap_plx locks up PC when reading PCI I/O memory
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dcbw@redhat.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
In-Reply-To: <20071212020325.96dbf41b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <479158.92576.qm@web52901.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-- Andrew Morton <akpm@linux-foundation.org> wrote: 
> hostap_plx.c first appeared in 2.6.14.
> 

Just a thought: How far back will I be able to compile kernels correctly with gcc 4.1.2?
Specifically:

gcc (GCC) 4.1.2 20070925 (Red Hat 4.1.2-33)

Cheers,
Chris



      __________________________________________________________
Sent from Yahoo! Mail - a smarter inbox http://uk.mail.yahoo.com

