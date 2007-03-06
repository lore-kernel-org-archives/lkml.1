Return-Path: <linux-kernel-owner+w=401wt.eu-S934121AbXCFNgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934121AbXCFNgp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 08:36:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934120AbXCFNgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 08:36:45 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:23420 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934119AbXCFNgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 08:36:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bSduOa3jPF+zFiyn8f9zZw3TLcikio+oJdZqPl07Xg8PNHhGsUkZ7GswHDAy8D6G6Ci1NxnUxLi7bQPkwlr3pWfgp93un9gqnQ+IKI1KCPtLuDqroIXuFnySmqJEFo2j1mxfbpXzfztnLLZiXSuHfWptk4TitV2nxqoU/Xlx3+U=
Message-ID: <d120d5000703060536k7743ece9hb20fa4d1f7ad7ad7@mail.gmail.com>
Date: Tue, 6 Mar 2007 08:36:36 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Eric Piel" <Eric.Piel@tremplin-utc.net>
Subject: Re: [PATCH] Wistron button support for TravelMate 610
Cc: mitr@volny.cz, otauber@web.de, linux-kernel@vger.kernel.org
In-Reply-To: <45ECA23A.5010503@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45ECA23A.5010503@tremplin-utc.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On 3/5/07, Eric Piel <Eric.Piel@tremplin-utc.net> wrote:
> Hello,
>
> Here is a patch adding support to wistron button for Acer TravelMate
> 610. This is tested and works fine with the exception of the leds which
> cannot be controlled (yet, that would require writing a led interface
> for them when I've got time ;-) )
>

I believe we have KEY_WLAN for Wifi, not KEY_XFER. I will fix that up.

> I'm sending just this one for now (as I can test it) but if you like it,
> I would like to try to add all the database of keyboards available in
> acerhk (that Olaf has written).

That would be nice. I have one request though - please send patches
inline instead of attachments, or, if you need to send it as an
attachment then put patch description and signed-off-by there as well
so I don't have to reassemble it.

-- 
Dmitry
