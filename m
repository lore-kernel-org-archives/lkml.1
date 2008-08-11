Return-Path: <linux-kernel-owner+w=401wt.eu-S1753218AbYHKNqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbYHKNqH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 09:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbYHKNpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 09:45:55 -0400
Received: from mail.bitdefender.com ([91.199.104.10]:44154 "EHLO
	mail.bitdefender.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbYHKNpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 09:45:54 -0400
From: Mihai =?utf-8?q?Don=C8=9Bu?= <mdontu@bitdefender.com>
Organization: BitDefender
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linuxinterfaceforon access scanning
Date: Mon, 11 Aug 2008 16:45:47 +0300
User-Agent: KMail/1.9.9
Cc: Adrian Bunk <bunk@kernel.org>, tvrtko.ursulin@sophos.com,
       Greg KH <greg@kroah.com>, "Press, Jonathan" <Jonathan.Press@ca.com>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       malware-list@lists.printk.net
References: <20080806105008.GF6477@cs181140183.pp.htv.fi> <200808070349.55882.mdontu@bitdefender.com> <20080806213904.37a33a58@infradead.org>
In-Reply-To: <20080806213904.37a33a58@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <200808111645.48177.mdontu@bitdefender.com>
X-BitDefender-Scanner: Clean, Agent: BitDefender qmail 3.0.0 on
 mail.bitdefender.com, sigver: 7.20466
X-BitDefender-Spam: No (0)
X-BitDefender-SpamStamp: v1, build 2.6.17.51344, bayes score: 500(0),
 pbayes score: 0(0), neunet score: 0(0), flags: [VALID_REPLY], total:
 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 August 2008, Arjan van de Ven wrote:
> On Thu, 7 Aug 2008 03:49:55 +0300
>
> Mihai Donțu <mdontu@bitdefender.com> wrote:
> > Well, here is one attempt.
> >
> > A good percentage of an AV product's job is to prevent exploitation
> > of a security hole in a product before the vendor (assuming the
> > vendor admits it's bug and not a misuse of the product's features).
>
> just to get things clear;
> you're not talking about preventing the actual exploitation per se
> (that would be the job of the various protection technologies) or the
> containment (that would be SELinux), but more about detecting the
> presence and preventing to (accidental) use of pre-canned, widely used
> exploit binaries/files ?

I apologize for the late reply. The answer to your question is: yes. I was 
planning to write some more on this subject but this is unnecessary now, 
because I see [almost] everyone accepted that some kind of antimalware 
scanning is needed and are looking for alternative (better) solutions to the 
patch that started all this.

Can't wait to see the end result. :)

Thanks,

-- 
Mihai Donțu
