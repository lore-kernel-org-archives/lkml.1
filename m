Return-Path: <linux-kernel-owner+w=401wt.eu-S1763364AbXFJX7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763364AbXFJX7T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 19:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760504AbXFJX7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 19:59:10 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:20198 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbXFJX7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 19:59:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=KwWbdf2ej6OPQGNLRByPpGPwXdym+wMb2rszp9S2p7tdAg4Z5rtrBRGPZsblN3F2XwRQ/tyn/SRoOlheNBrrE/sdWx2jjsmx6W9f75ZaSb0potzSA89D2y6IjVLSdQx68NNtf0UgZDemXzcQjvWGUak/nKCye1vxHE7hW8ZPHD8=
From: Denis Vlasenko <vda.linux@googlemail.com>
To: Rene Herman <rene.herman@gmail.com>
Subject: Re: kconfig .po files in kernel tree? [Was: Documentation/HOWTO translated into Japanese]
Date: Mon, 11 Jun 2007 01:59:00 +0200
User-Agent: KMail/1.8.2
Cc: Sam Ravnborg <sam@ravnborg.org>, Greg KH <gregkh@suse.de>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Tsugikazu Shibata <tshibata@ab.jp.nec.com>,
       linux-kernel@vger.kernel.org, m-ikeda@ds.jp.nec.com
References: <20070610.204845.115909592.tshibata@ab.jp.nec.com> <20070610175228.GA28947@uranus.ravnborg.org> <466C49DB.6040409@gmail.com>
In-Reply-To: <466C49DB.6040409@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706110159.00482.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 10 June 2007 20:58, Rene Herman wrote:
> All that stuff only serves to multiply the speed at which a fixed percentage 
> of content obsoletes itself. When it's still new and shiny, sure, stuff will 
> get translated but in no time at all it'll become a fragmented mess which 
> nobody ever feels right about removing because that would be anti-social to 
> all those poor non-english speaking kernel hackers out there.

I agree. i18n efforts won't help one iota because people just have
to know English in order to participate in l-k development.
They should be able to read _and_ reply_ to lkml posts,
and read and understnd code _and_ comments_.

Those who cannot participate in development because they don't
know English, won't get much help from some bits of semi-obsolete
Documentation/* being available. Ok, they will read it, then what?
How they are supposed to read the code? Write email? etc...

There is only one practical solution: learn the language.

It's not about *English* per se. It just happened so historically
that CS has originated in English speaking countries.

BTW, I learned it by reading sci-fi (Asimov's Foundation was the first thing),
and then lkml. :)
--
vda
