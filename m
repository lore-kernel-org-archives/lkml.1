Return-Path: <linux-kernel-owner+w=401wt.eu-S1754825AbZFEEUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbZFEEUr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 00:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbZFEEUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 00:20:31 -0400
Received: from mail.tmr.com ([64.65.253.246]:41489 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739AbZFEEUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 00:20:30 -0400
Message-ID: <4A289B96.7030808@tmr.com>
Date: Fri, 05 Jun 2009 00:14:14 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090507 Fedora/1.1.16-1.fc9 pango-text SeaMonkey/1.1.16
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: tglx@linutronix.de, george.dunlap@eu.citrix.com, davem@davemloft.net,
       jeremy@goop.org, mingo@elte.hu, dan.magenheimer@oracle.com,
       avi@redhat.com, xen-devel@lists.xensource.com, x86@kernel.org,
       linux-kernel@vger.kernel.org, Keir.Fraser@eu.citrix.com,
       torvalds@linux-foundation.org, gregkh@suse.de, kurt.hackel@oracle.com,
       Ian.Pratt@eu.citrix.com, xen-users@lists.xensource.com,
       ksrinivasan@novell.com, EAnderson@novell.com, wimcoekaerts@wimmekes.net,
       stephen.spector@citrix.com, jens.axboe@oracle.com
Subject: Re: Xen is a feature
References: <162f4c90-6431-4a2a-b337-6d7451d7b11e@default> <20090528001350.GD26820@elte.hu> <4A1F302E.8030501@goop.org> <20090528.210559.137121893.davem@davemloft.net> <4A1FCE8E.2060604@eu.citrix.com> <alpine.LFD.2.00.0905311607560.3379@localhost.localdomain> <4A26D3D8.6080002@tmr.com> <alpine.LFD.2.00.0906032204220.3419@localhost.localdomain> <alpine.LFD.2.00.0906032204220.3419@localhost.localdomain> <4A26FB3B.6010205@tmr.com> <200906040129.07852.elendil@planet.nl>
In-Reply-To: <200906040129.07852.elendil@planet.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> Bill Davidsen wrote:
>   
>> I was referring to your "no benefit" comment, I don't dispute the
>> technical issues. I think the idea of moving the hypervisor into the
>> kernel and letting xen folks do the external parts as they please.
>>     
>
> Where does that come from? AFAICT Thomas never made a "no benefit" comment 
> other than limited to the context of the technical implementation.
>
>   
Where it comes from is his very recent statement, which contains those 
very words. You may interpret what he said in any way you choose, but 
denying that he said it shows that you didn't follow the link back. I 
never denied the ugliness of the code, nor does the author, but it adds 
a great deal of value for many people, and that's the point I was making.

-- 
Bill Davidsen <davidsen@tmr.com>
  Even purely technical things can appear to be magic, if the documentation is
obscure enough. For example, PulseAudio is configured by dancing naked around a
fire at midnight, shaking a rattle with one hand and a LISP manual with the
other, while reciting the GNU manifesto in hexadecimal. The documentation fails
to note that you must circle the fire counter-clockwise in the southern
hemisphere.


