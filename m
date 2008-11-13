Return-Path: <linux-kernel-owner+w=401wt.eu-S1753650AbYKMUqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650AbYKMUqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 15:46:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbYKMUp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 15:45:59 -0500
Received: from rn-out-0910.google.com ([64.233.170.184]:2000 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbYKMUp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 15:45:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uxOTmUknL75WWk8AFdBQ8zmSdoffTqVVwamrXAW4oV/O17QNaJdTrTF1Fp2FSVo9Ns
         Wbk8YtUP0gnusQL3bPsHkGf+qh+RhESPeyF4CZCypKsKMZ/dNyEiPMH+8slhg5h5TdOS
         pif1qI0rz1pUO3mE0s9YpBWA7giNOfbciW3iw=
Message-ID: <43e72e890811131238s1cda9f9dsadaa23fc36c3cd93@mail.gmail.com>
Date: Thu, 13 Nov 2008 12:38:24 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: sclark46@earthlink.net
Subject: Re: [madwifi-project] [RFC] Closing the project
Cc: "Pavel Roskin" <proski@gnu.org>,
       "Michael Renzmann" <mrenzmann@madwifi-project.org>,
       madwifi-project@venema.h4ckr.net,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <491C8C48.3030602@earthlink.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2576.194.45.26.221.1226491274.squirrel@webmail.madwifi.org>
	 <1226511194.9952.38.camel@dv>
	 <43e72e890811121224w4fc53e1s29080a42111186e9@mail.gmail.com>
	 <1226547092.11785.49.camel@dv>
	 <43e72e890811131142p3f72c964t802d424b0ddb3456@mail.gmail.com>
	 <491C8C48.3030602@earthlink.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2008 at 12:21 PM, Stephen Clark <sclark46@earthlink.net> wrote:
> Luis R. Rodriguez wrote:

>> Just my advice: let MadWifi die already, stop wasting your time.
>
> Yeah but ath5k doesn't work on my zyxel ar5212 based wireless card only
> madwifi works!

The discussion is about further pushing MadWifi vs keeping it in only
maintenance mode. In your case the code would still exist until ath5k
make it work appropriately.

Also -- what kernel have you tried ath5k on that it does not work on?
Have you tried compat-wireless? Keep in mind to use the latest you'll
need at least 2.6.27 installed.

  Luis
