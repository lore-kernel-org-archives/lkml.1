Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbYEPERV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbYEPERV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 00:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbYEPERJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 00:17:09 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:13006 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbYEPERH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 00:17:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YrTUC60mum3mE0zzkDVyb3S1H4Yr9LuhdlBZQpMkF3vHEiZkq1NW8PvjlfZVDCxb163tnqqhGJfuleN+jYKD4MNGT+w/CjPu+7D9i5WhyIZPaUNNcfkcYQMqfL/zzQwOqLQUwxCRoF62Noff1ZsQlkzc9ozVrCjHlpPz29YiqZ4=
Message-ID: <aa79d98a0805152117p205303c9w3732b403c34ce8e0@mail.gmail.com>
Date: Fri, 16 May 2008 08:17:06 +0400
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>, geert@linux-m68k.org,
       torvalds@linux-foundation.org, zippel@linux-m68k.org, schwab@suse.de,
       linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org
Subject: Re: [PATCH] init - fix building bug and potential buffer overflow
In-Reply-To: <aa79d98a0805152029l6aeacae4rb7c54ff047177c70@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080514154402.GF6902@cvg>
	 <20080515105803.7c9ab8c7.akpm@linux-foundation.org>
	 <20080515180528.GC7481@cvg> <Pine.LNX.4.64.0805152132530.22059@anakin>
	 <aa79d98a0805151322s20a2bb34x4491bcacfcef310@mail.gmail.com>
	 <20080515134928.83b2d948.akpm@linux-foundation.org>
	 <aa79d98a0805152029l6aeacae4rb7c54ff047177c70@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 7:29 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> Yes! Exactly! Thanks, Andrew! (i didn't look into what Linus suggested
> 'cause i just waked up and have to go to my job)
>
[...]

And sorry about top-posting (gmail mobile client is really screwed up,
trying to force top-post all the time)
