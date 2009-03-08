Return-Path: <linux-kernel-owner+w=401wt.eu-S1755405AbZCHXCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbZCHXCm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 19:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754875AbZCHXCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 19:02:33 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:56263 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854AbZCHXCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 19:02:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=M/uUUH7ABfv0DBtm9txaBsPUoV81HvME54mc3IarIRji6ghinecRJRZOKxxFN95LwS
         ElbLvH0wyncZ6DTG8nRTvYu9Hd4Fd3jaHUkYDZPQEat2uRwYkeGPi4HTaGB7gkcF6KD/
         f0GV+oij7GyduJyU1Tww1tarB+dgdbhGcXL6o=
MIME-Version: 1.0
In-Reply-To: <43e72e890903022314o44ae710u834d6207403fd4a2@mail.gmail.com>
References: <43e72e890903022314o44ae710u834d6207403fd4a2@mail.gmail.com>
Date: Mon, 9 Mar 2009 00:02:30 +0100
Message-ID: <c384c5ea0903081602j5d8a91b7pad5eec80fffd3274@mail.gmail.com>
Subject: Re: Staging, place holder for better company/community development 
	model
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jouni Malinen <j@w1.fi>, Sujith <m.sujith@gmail.com>,
       Sujith <Sujith.Manoharan@atheros.com>,
       Senthilkumar Balasubramanian 
	<Senthilkumar.Balasubramanian@atheros.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Christoph Hellwig <hch@infradead.org>,
       Vasanthakumar Thiagarajan <vasanth@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Mar 3, 2009 at 8:14 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>
> With future devices we may want to create a better path for
> integration into upstream drivers. But I also want users to get
> support for the devices as soon as those devices hit shelves in the
> market, maybe even before.
>
The situation prior to the staging/ tree, was that niche drivers often
lived outside of the kernel tree, without much exposure and without
API consistency.

With staging/ available, there should be no reason for either a
company or individual(s) to develop a Linux driver outside the kernel
tree.

A driver can live there until enough momentum (devices in the field,
in Linux developer hands) exists to have the driver reworked for main
tree clearance.

At least, with this in the back of my head I submitted my driver to
staging which would otherwise live in a secret place. I have contacted
the hardware vendor and they are (not yet) interested in Linux
support. I am counting the days before they will.

Regards,
-- 
Leon
