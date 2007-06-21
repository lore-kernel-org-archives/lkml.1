Return-Path: <linux-kernel-owner+w=401wt.eu-S1752867AbXFUXIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867AbXFUXIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 19:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751064AbXFUXIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 19:08:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34816 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbXFUXIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 19:08:30 -0400
Message-ID: <467B04EB.2010105@redhat.com>
Date: Thu, 21 Jun 2007 19:08:27 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: Jesper Juhl <jesper.juhl@gmail.com>,
       Zolt?n HUBERT <zoltan.hubert@zzaero.com>, linux-kernel@vger.kernel.org
Subject: Re: Please release a stable kernel Linux 3.0
References: <200706212349.54983.zoltan.hubert@zzaero.com> <9a8748490706211529yca0588dgd1f7e0b86f7e4a62@mail.gmail.com> <467AFCEC.2070203@redhat.com> <20070621230126.GF10008@csclub.uwaterloo.ca>
In-Reply-To: <20070621230126.GF10008@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2007 07:01 PM, Lennart Sorensen wrote:
> On Thu, Jun 21, 2007 at 06:34:20PM -0400, Chuck Ebbert wrote:
>> Even the good ones that get lots of fixes aren't all that good. The
>> biggest problem ATM is that suspend is badly broken and keeps getting
>> worse...
> 
> I wasn't under the impression suspend had really ever worked.  Such a
> messy problem to solve.
> 

It never worked reliably for everyone, but with each new release it
seems to get worse.
