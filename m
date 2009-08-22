Return-Path: <linux-kernel-owner+w=401wt.eu-S933023AbZHVVBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933023AbZHVVBM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 17:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932365AbZHVVBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 17:01:11 -0400
Received: from lucidpixels.com ([75.144.35.66]:48325 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755699AbZHVVBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 17:01:10 -0400
Date: Sat, 22 Aug 2009 17:01:12 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Christoph Hellwig <hch@infradead.org>
cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Kernel 2.6.30.4 XFS(..?) regression (& with/2.6.31-rc6)
In-Reply-To: <20090822205502.GA18904@infradead.org>
Message-ID: <alpine.DEB.2.00.0908221659030.23463@p34.internal.lan>
References: <00980BBF-1206-4BEF-A8AE-B4A8DAE7EC27@sgi.com> <alpine.DEB.2.00.0908090605080.16485@p34.internal.lan> <alpine.DEB.2.00.0908110624420.22426@p34.internal.lan> <20090816022331.GA2309@infradead.org> <alpine.DEB.2.00.0908171024380.12533@p34.internal.lan>
 <alpine.DEB.2.00.0908220624440.30321@p34.internal.lan> <20090822142550.GA10003@infradead.org> <alpine.DEB.2.00.0908221044420.30321@p34.internal.lan> <20090822201558.GA17955@infradead.org> <alpine.DEB.2.00.0908221645440.20848@p34.internal.lan>
 <20090822205502.GA18904@infradead.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 22 Aug 2009, Christoph Hellwig wrote:

> On Sat, Aug 22, 2009 at 04:46:52PM -0400, Justin Piszcz wrote:
>>> Well, that would be a good way to find it.  But I'm personally not
>>> interested in spending much time on debugging a problem if it only
>>> happens with fishy out of tree modules.
>>>
>>
>> .. No out of tree modules are used ..
>
> Your previous mail said it only happened using loop-aes.  Is that the
> case or not?
>

My mistake,

Sorry for the confusion-- it is cryptoloop on this particular host:

[note to self]:
http://tldp.org/HOWTO/html_single/Cryptoloop-HOWO/

Justin.




