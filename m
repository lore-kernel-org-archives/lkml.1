Return-Path: <linux-kernel-owner+w=401wt.eu-S1759962AbYGRQRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759962AbYGRQRU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 12:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbYGRQRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 12:17:12 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:47192 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255AbYGRQRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 12:17:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kQsln85dEJkvAUN0mWPdcvF6fZ6VrF9Ex90eV45dYdi2YaKQ19jI1aONeirtriijLp
         WBytliCGxCXe8JURKRKo4bMZt1nrlCOUi0DBfVc5nx2qWotFzjCGa5aMJKlAoSeD0evi
         qAKKp2l9MaOUhr1pBkEBllb0/GqiQBcfp89sQ=
Message-ID: <86802c440807180917r3cf3a237w4d6e5635bb49bae0@mail.gmail.com>
Date: Fri, 18 Jul 2008 09:17:10 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jack Howarth" <howarth@bromo.msbb.uc.edu>
Subject: Re: 2.6.26-rc9-git9 doesn't boot on Macintel
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20080718160739.GA5560@bromo.msbb.uc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080717004004.GA17792@bromo.msbb.uc.edu>
	 <20080717023538.GA18329@bromo.msbb.uc.edu>
	 <86802c440807161959s10666027k5297af1d657ff4fa@mail.gmail.com>
	 <20080717034418.GA18951@bromo.msbb.uc.edu>
	 <86802c440807162113g4cea3bd9ic71210330417032b@mail.gmail.com>
	 <20080717061825.GA19582@bromo.msbb.uc.edu>
	 <86802c440807162348m6d05b912x7b3f655d7f9efb93@mail.gmail.com>
	 <20080718011532.GA30920@bromo.msbb.uc.edu>
	 <86802c440807171825m24ffe140o81bb76286823568e@mail.gmail.com>
	 <20080718160739.GA5560@bromo.msbb.uc.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 9:07 AM, Jack Howarth <howarth@bromo.msbb.uc.edu> wrote:
> YH,
>   Is there any relationship between the issue fixed in...
>
> http://marc.info/?l=linux-acpi&m=121615159014404&w=2
>
> and the DMI issue you patched on my MacBookPro v2?

no, the dmi check need to be done before reject_check...

YH
