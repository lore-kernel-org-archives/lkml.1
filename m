Return-Path: <linux-kernel-owner+w=401wt.eu-S1758053AbYHAVno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbYHAVno (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbYHAVne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:43:34 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:38835 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464AbYHAVnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:43:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=czRaFG0obiRUto3HwGL3QnY7zdKlm1R6zVA9gG2AgqPfNBDGzEGyMDyRDfq19Vo5YJ
         oZPlzR2eVsfd8YiXBVz2YFv2412nvP0XeMbn8e9kSP2h/DyJoJN6DgvMUqflzin02LAX
         T23eGN1DcGaizEaWobVaXSmqOAPw7NZ9GzWUY=
Message-ID: <1ba2fa240808011443u1a5553fpfca046f047773217@mail.gmail.com>
Date: Sat, 2 Aug 2008 00:43:32 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: pull request: wireless-2.6 2008-08-01
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080801205830.GA10071@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080801205830.GA10071@tuxdriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 1, 2008 at 11:58 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> Dave,
>
> Another big batch of wireless fixes for 2.6.27.  The ath5k series is
> more than fixes, but I included it because it enables new ath5k
> hardware.  (The ath5k.h changes in particular are documentation cleanups
> for registers based on info gleaned from the newly posted ath9k driver.)
> The others patches are fixes, some more obvious than others. :-)
>
> Let me know if there are any problems!

All the iwlwifi patches should go up otherwise the support for 5000 HW
will be incomplete.
Tomas.
