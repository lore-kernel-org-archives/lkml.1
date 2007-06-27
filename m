Return-Path: <linux-kernel-owner+w=401wt.eu-S1763776AbXF0Wgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763776AbXF0Wgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 18:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761070AbXF0Wg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 18:36:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:58331 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760254AbXF0Wg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 18:36:27 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Linux Kernel include files
To: Arjan van de Ven <arjan@infradead.org>,
       Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>, bunk@stusta.de,
       schilling@fokus.fraunhofer.de, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Thu, 28 Jun 2007 00:35:34 +0200
References: <8AGnE-33a-15@gated-at.bofh.it> <8AISu-6Qn-31@gated-at.bofh.it> <8AISu-6Qn-29@gated-at.bofh.it> <8AKUp-1wx-41@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1I3g6o-00012P-Hn@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/4cjdkefMPUKw1mdObQwg9UqqGqaFTIlP0Yw3
 tglHaR1NKbXibjJVnP8r+2IeBD7GImMSsQxNlsG6US/hrzTHZ3
 l6zYOiM6hJMGwO4upzpbg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> wrote:
> On Wed, 2007-06-27 at 18:41 +0200, Joerg Schilling wrote:

>> Well, I did report these kind of problems many years ago and as it has not
>> been fixed after some years, I was asuming that it is still the way I see it
>> on Suse 10.0.
> 
> I'd suggest reporting SuSE bugs to SuSE; that's more effective ;)
> (although I don't know how they will deal with bugreports against older
> versions)
> 
> your bug looks certainly valid.. just you're not using the "proper"
> header set that the kernel developers suggest ;)

Even though you put the smiley there, it does not seem fair to expect people
to know the latest bits of kernel developement and deployment procedures
unless hanging around on lkml is a requirement for linux users. I'm just
browsing that list, filtering and ignoring a lot. If I didn't do that, I
would not even suspect something like make headers_install to exist, nor
would I try to search for it.

@Jörg: The responsibility to maintain clean headers shifted only recently,
and there is possibly still a lot to do. If you can point out errors, they
can and probably will be fixed. But as you know, having a precise error
message or description does help.
-- 
W.I.N.D.O.W.S.:
 Wireless Intelligent Neohuman Designed for Observation and Worldwide Sabotage
        -- http://www.brunching.com/toys/toy-cyborger.html (down)
Friß, Spammer: IQ@7eggert.dyndns.org kgrQit6@p.7eggert.dyndns.org
