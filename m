Return-Path: <linux-kernel-owner+w=401wt.eu-S1757606AbYGQQmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606AbYGQQmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 12:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755495AbYGQQmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 12:42:46 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:29267 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178AbYGQQmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 12:42:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=FuPr9vqFL2R0AV/1d0SU3GawhqO9d7UUGNLcpESdngqyp6mZv9MAMeaKiaLcsXKbBH
         3L14D5cYpu91HYmPqkpTdBF93sHEgey3u2I+U2oWVmjlNY7KdDn73bcNExXWCSCTUn65
         om/QhQWMjdpIfPo/FbSOwCzuI7/ffSdr7lgZM=
Message-ID: <86802c440807170942k387c7d73o838584d99457bd30@mail.gmail.com>
Date: Thu, 17 Jul 2008 09:42:44 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jack Howarth" <howarth@bromo.msbb.uc.edu>
Subject: Re: 2.6.26-rc9-git9 doesn't boot on Macintel
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20080717162622.GA26835@bromo.msbb.uc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440807161029n7e0dac98x1ec260879204b6f0@mail.gmail.com>
	 <20080717004004.GA17792@bromo.msbb.uc.edu>
	 <86802c440807161749u2f5c1eben618e05c6e254fedd@mail.gmail.com>
	 <20080717023538.GA18329@bromo.msbb.uc.edu>
	 <86802c440807161959s10666027k5297af1d657ff4fa@mail.gmail.com>
	 <20080717034418.GA18951@bromo.msbb.uc.edu>
	 <86802c440807162113g4cea3bd9ic71210330417032b@mail.gmail.com>
	 <20080717061825.GA19582@bromo.msbb.uc.edu>
	 <86802c440807162348m6d05b912x7b3f655d7f9efb93@mail.gmail.com>
	 <20080717162622.GA26835@bromo.msbb.uc.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 9:26 AM, Jack Howarth <howarth@bromo.msbb.uc.edu> wrote:
> YH,
>   I am wondering if it might be worthwhile for me to
> try the various rc releases of 2.6.26 (starting with rc1-git1)
> to see if I can identify at what point 2.6.26 was broken
> with regards to booting on my MacBook Pro? In case that
> would point us towards the checkin of a specific set of
> patches as the problem.

try 2.6.26-rc1,..rc2

YH
