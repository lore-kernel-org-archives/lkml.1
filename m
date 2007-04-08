Return-Path: <linux-kernel-owner+w=401wt.eu-S1751934AbXDHT0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbXDHT0j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 15:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbXDHT0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 15:26:39 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:43061 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbXDHT0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 15:26:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZW1fNZPq5fEXR3roX+KWx8HucywP6c0mBkfk0/Vsz7E2YwM5hYS475fN601Rw63xG0Ta5AzeqQnNHGZQeG5d15fiu/D0WfrbW7/FlZ/a6sx7UHLARawXEr+ykgUwoPnhdI5kgHcLrOnATJrganNJgr4/+I5t5pJO/EKmV15/rK8=
Message-ID: <a36005b50704081226t62bb08d0o217f91d5bc7a3a7e@mail.gmail.com>
Date: Sun, 8 Apr 2007 12:26:37 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Theodore Tso" <tytso@mit.edu>,
       "=?ISO-8859-1?Q?J=F6rn_Engel?=" <joern@lazybastard.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Ulrich Drepper" <drepper@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Neil Brown" <neilb@suse.de>
Subject: Re: If not readdir() then what?
In-Reply-To: <20070408191955.GD29180@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a36005b50704070957v2d2e6c4g5fac49b5ff1a5789@mail.gmail.com>
	 <20070407203633.GA21555@thunk.org>
	 <20070407233037.GA16508@infradead.org> <46193048.6000606@zytor.com>
	 <20070408184129.GA20871@lazybastard.org>
	 <20070408191955.GD29180@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/8/07, Theodore Tso <tytso@mit.edu> wrote:
> Ulrich, is it too late to insert a clarification that the telldir()
> cookie isn't guaranteed to be valid after closedir() *or* rewinddir()?

It's never too late.
