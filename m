Return-Path: <linux-kernel-owner+w=401wt.eu-S1754828AbXEXX1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbXEXX1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 19:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbXEXX1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 19:27:09 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:60198 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbXEXX1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 19:27:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dgx4TX9OaXj6bQv9OMQWnMbGJFn6vjqXThmmEe7+WdhJ95DummQa4hxWgVWgAYEFnXBS2lMD+l67xwqW3WSmA2urWE6MS60S5eItxg8X1Wyi9hsqjouIZLpX0UIDUYt9gAk4L/aNcnNDW/7hqhI3blpNhCp62QQmnPnyYxoQgBU=
Message-ID: <9a8748490705241627g546d5002g9c8dc87b37d32995@mail.gmail.com>
Date: Fri, 25 May 2007 01:27:06 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Remove a few UMSDOS leftovers
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jacques Gelinas" <jacques@solucorp.qc.ca>,
       "Matija Nalis" <mnalis@jagor.srce.hr>,
       "Matija Nalis" <mnalis@voyager.hr>, trivial@kernel.org
In-Reply-To: <46561E9A.7020402@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705250058.29266.jesper.juhl@gmail.com>
	 <46561AA5.8090908@zytor.com>
	 <200705250115.04491.jesper.juhl@gmail.com>
	 <46561E9A.7020402@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/05/07, H. Peter Anvin <hpa@zytor.com> wrote:
> Jesper Juhl wrote:
> > Ok, that makes sense. How about this version :
>
> Could you document which numbers were actually used by umsdos, instead
> of reserving a full block of 256?  Since it's dead, it's not going to
> eat any more numbers.
>
Sure, I'll dig out that information and prepare a new patch tomorrow
(need to catch some sleep right now).

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
