Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbXFVAQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbXFVAQo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 20:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbXFVAQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 20:16:34 -0400
Received: from exchange.columbia.tresys.com ([216.250.243.126]:3057 "HELO
	exchange.columbia.tresys.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751660AbXFVAQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 20:16:32 -0400
Message-ID: <467B14D9.8050000@manicmethod.com>
Date: Thu, 21 Jun 2007 20:16:25 -0400
From: Joshua Brindle <method@manicmethod.com>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Lars Marowsky-Bree <lmb@suse.de>
CC: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Pavel Machek <pavel@ucw.cz>, Crispin Cowan <crispin@novell.com>,
       Greg KH <greg@kroah.com>, Andreas Gruenbacher <agruen@suse.de>,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
References: <20070615200623.GA2616@elf.ucw.cz> <20070615211157.GB7337@kroah.com> <46732124.80509@novell.com> <20070616000251.GG2616@elf.ucw.cz> <20070621160840.GA20105@marowsky-bree.de> <20070621183311.GC18990@elf.ucw.cz> <20070621192407.GF20105@marowsky-bree.de> <Line.LNX.4.64.0706211530290.483@localhost.localdomain> <20070621195400.GK20105@marowsky-bree.de> <1182459594.20464.16.camel@moss-spartans.epoch.ncsc.mil> <20070621211743.GN20105@marowsky-bree.de>
In-Reply-To: <20070621211743.GN20105@marowsky-bree.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Jun 2007 00:16:30.0785 (UTC) FILETIME=[954ACB10:01C7B462]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lars Marowsky-Bree wrote:
> On 2007-06-21T16:59:54, Stephen Smalley <sds@tycho.nsa.gov> wrote:
> <snip>
>
>   
>> Um, no.  It might not be able to directly open files via that path, but
>> showing that it can never read or write your mail is a rather different
>> matter.
>>     
>
> Yes. Your use case is different than mine.
>   

So.. your use case is what? If an AA user asked you to protect his mail 
from his browser I'm sure you'd truthfully answer "no, we can't do that 
but we can protect the path to your mail from your browser".. I think 
not. One need only look at the wonderful marketing literature for AA to 
see what you are telling people it can do, and your above statement 
isn't consistent with that, sorry.

