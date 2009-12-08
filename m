Return-Path: <linux-kernel-owner+w=401wt.eu-S1753889AbZLHHXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbZLHHXt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 02:23:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbZLHHXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 02:23:48 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:39019 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbZLHHXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 02:23:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TRuO+TsH5dThIkZWPiy+sdlAEU/lkKd//0W6OS1G8S7B3Jv72P7mWR+LF4SZFXNbnk
         Uj4k5VJ9coCp191TOHwE/KJ54dBq60+WS86zMU/K060MxHahcR1Cuy/TN6AMjg8UNwZL
         csDz5rf/4Q/DKQoHvbK4B6ijecNFtggIgeU0E=
Date: Mon, 7 Dec 2009 23:23:47 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, akpm@linux-foundation.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       "Rafael J . Wysocki" <rjw@sisk.pl>, zhangfx@lemote.com,
       linux-laptop@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v8 8/8] Loongson: YeeLoong: add input/hotkey driver
Message-ID: <20091208072347.GH11147@core.coreip.homeip.net>
References: <cover.1260082252.git.wuzhangjin@gmail.com> <b164d5bb79963a57621d024c22e5664de0ff8662.1260082252.git.wuzhangjin@gmail.com> <20091207064857.GG21451@core.coreip.homeip.net> <1260255131.3315.25.camel@falcon.domain.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260255131.3315.25.camel@falcon.domain.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08, 2009 at 02:52:11PM +0800, Wu Zhangjin wrote:
> Hi, Dmitry Torokhov
> 
> I plan to send another revision of this patchset, Can I get your
> Acked-by: for this patch?
> 

Yes, as far as the input code goes:

	Acked-by: Dmitry Torokhov <dtor@mail.ru>

Thanks.

-- 
Dmitry
