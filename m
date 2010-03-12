Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934138Ab0CLRkY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 12:40:24 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:24384 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933816Ab0CLRkS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 12:40:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=OZGXdicB++N9IRW+mu4CXvbwe72xSSkGB9uZWITbu56rNpSaogUGPl0vsZ7g0rpZOm
         3H6HnuK0pik7dw9swX/mPtFfiI1q1owQiT4NnrAPvRAjmUUmKQB6ut899pChaAimCcxi
         bkzKP8ehR0FgoZdhyYmSauXDTzsTMAwDRzuDk=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Michal Hocko <mstsxfx@gmail.com>
Subject: Re: unable to handle kernel paging request on resume with 2.6.33-00001-gbaac35c
Date: Fri, 12 Mar 2010 18:40:13 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33; KDE/4.3.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <20100301175256.GA4034@tiehlicka.suse.cz>
In-Reply-To: <20100301175256.GA4034@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003121840.13938.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On poniedziałek, 1 marca 2010 o 18:52:57 Michal Hocko wrote:
> Hi,
> 
> I have experienced the following kernel BUG on resume from suspend from
> disk (the whole log from  hibarnation to suspend along with kernel
> config are attached):
> 

I created a Bugzilla entry at http://bugzilla.kernel.org/show_bug.cgi?id=15526
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
