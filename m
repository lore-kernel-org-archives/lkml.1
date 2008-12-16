Return-Path: <linux-kernel-owner+w=401wt.eu-S1757990AbYLPPkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990AbYLPPkl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 10:40:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755152AbYLPPkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 10:40:33 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:28629 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613AbYLPPkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 10:40:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=vfhBfdEE4Z65I2QXhJlvu2ljA0W0z3HEKr8UYzaISHzUcyF+lU8IuQBrmYfh8jCBec
         5qCFe7CSX4U81JAw9RxseEJVD0ftNmz1l7klYtq9F0VY7vrcm1jXOmSkdb/CVFafDl+i
         y9zOIbO9OPWyWZ6FhhVgW956X0vM/M9NjXdGM=
Message-ID: <3f9a31f40812160740o4559e37bi2e664789a5963167@mail.gmail.com>
Date: Tue, 16 Dec 2008 21:10:30 +0530
From: "Jaswinder Singh" <jaswinderlinux@gmail.com>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: BUG - HDA Intel very low audio with breaking voice in 2.6.28-rc8
Cc: linux-kernel@vger.kernel.org, andy.kopp@intel.com, dan.d.kogan@intel.com,
       pshou@realtek.com.tw
In-Reply-To: <s5h1vw9rjap.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3f9a31f40812132358x27df1788re521e47b8dbe2cd1@mail.gmail.com>
	 <s5hr64b151n.wl%tiwai@suse.de>
	 <3f9a31f40812140330w7aa55e55n2159f095cbafd018@mail.gmail.com>
	 <s5h1vw9rjap.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Takashi,

On Mon, Dec 15, 2008 at 12:56 PM, Takashi Iwai <tiwai@suse.de> wrote:
> But, if the other kernel version shows the same behavior, it's no help
> actually.

After updating the system, voice breaking is fixed.

I am quite happy with this.

Thanks for your help,

Jaswinder Singh.
