Return-Path: <linux-kernel-owner+w=401wt.eu-S1760959AbXEOIad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760959AbXEOIad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 04:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757321AbXEOIa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 04:30:26 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:64705 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757279AbXEOIaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 04:30:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=I5zUFBlELmocgAG8RpqcjIJx0pICOX4DBy15rGsM4YRuDCb/jUaNRGgyy5DJhkEui2YZcnZ0IQZsNBD5pORUPerQMtIXu2DbTaqHprAgUf/bCOCaropq42JgbbJaZvNW35fvUKoaqL4D2RCewZWet7MvYbQAWw5DOKPukCi5mAs=
Message-ID: <6bffcb0e0705150130v4bef7925jdb4f0a5accde650e@mail.gmail.com>
Date: Tue, 15 May 2007 10:30:24 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "S K" <kernelandme@gmail.com>
Subject: Re: Masking console output at boot time
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <b2981f030705150123i286b61dape5c3de9cc170d9e0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b2981f030705150123i286b61dape5c3de9cc170d9e0@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 15/05/07, S K <kernelandme@gmail.com> wrote:
> Hi -
> I want to mask all the messsages that are printed on console at boot
> time. I am looking for an approach, in which we can print '#' for
> every line of output sent to console at boot time.

No! :)

> Can anybody suggest me something in this regard.

You can add "quiet" to the command line.

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
