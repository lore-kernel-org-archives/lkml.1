Return-Path: <linux-kernel-owner+w=401wt.eu-S1759069AbZC1Dzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759069AbZC1Dzl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 23:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756820AbZC1Dza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 23:55:30 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:53940 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924AbZC1Dza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 23:55:30 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: Linux 2.6.29
Date: Fri, 27 Mar 2009 23:55:06 -0400
User-Agent: KMail/1.11.1 (Linux/2.6.28.9; KDE/4.2.1; i686; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20090327051338.GP6239@mit.edu>
 <alpine.LFD.2.00.0903271840450.3994@localhost.localdomain>
 <49CD9120.1010009@garzik.org>
In-reply-to: <49CD9120.1010009@garzik.org>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
Message-id: <200903272355.06367.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 March 2009, Jeff Garzik wrote:
>Linus Torvalds wrote:
>> On Fri, 27 Mar 2009, Jeff Garzik wrote:
>>> Definitely a difference!   1 for both, here.  Deb is a fresh OS install
>>> and fresh homedir, but my F10 has been through many OS and ff config
>>> upgrades over the years.
>>
>> Hmm. I wonder where firefox gets its defaults then.
>>
>> I can well imagine that Debian has a different firefox build, with
>> different defaults. But if your F10 thing also is set to 1, and still
>> shows as "default", then that's odd, considering that mine shows 0.
>>
>> I have 'rpm -q firefox': firefox-3.0.7-1.fc10.x86_64.
>>
>> Is yours a 32-bit one? Maybe it comes with different defaults?
>>
>> And maybe firefox just has a very odd config setup and I don't understand
>> what "default" means at all. Gene says he doesn't have that
>> toolkit.storage.synchronous thing at all.
>
>In my case the toolkit.storage.synchronous is present in both, set to 1
>in Deb and bolded and set to 1 in F10 (firefox-3.0.7-1.fc10.x86_64).
>
>The latter's bold typeface makes me think my F10 FF
>toolkit.storage.synchronous setting is NOT set to the F10 default --
>although I have never heard of this setting, and have certainly not
>manually tweaked it.  The only FF setting I manually tweak is cache
>directory.
>
>	Jeff

I just let FF update itself to 3.0.8 (from mozilla, not fedora) and there is 
no 'toolkit' stuff whatsoever in about:config.

Is this perchance some extension I don't have installed?
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/


-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Jacquin's Postulate on Democratic Government:
	No man's life, liberty, or property are safe while the
	legislature is in session.

