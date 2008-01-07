Return-Path: <linux-kernel-owner+w=401wt.eu-S1757564AbYAGRmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564AbYAGRmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 12:42:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754710AbYAGRmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 12:42:16 -0500
Received: from wr-out-0506.google.com ([64.233.184.233]:35152 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180AbYAGRmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 12:42:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=vguI0EMiVJo9x2odZzbweAoO7ASWQuFAlU6KVDlRUFh6yds/OSzFWuU5FK4b4lA4frw7sFxCnHqvI3VkTCPmX8qxbmJ/GkS58s2FhLKay45uIcNq48C3WatNpRslOTVhr0FcW9IwXeg4QtYf3l2ub9prOU0jeP5wdcDgoT2Q1ZM=
Message-ID: <43e72e890801070942y5abcc8acs31ac446d67414483@mail.gmail.com>
Date: Mon, 7 Jan 2008 12:42:13 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: "Hauke Mehrtens" <hauke@hauke-m.de>
Subject: Re: rtl8187 rate control doesn't work
Cc: "Michael Wu" <flamingice@sourmilk.net>, linux-kernel@vger.kernel.org,
       "Stefano Brivio" <stefano.brivio@polimi.it>,
       linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <47824D25.5090005@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <477F9890.5050107@hauke-m.de>
	 <43e72e890801051354v280c0ceeo78790bb5f1f45314@mail.gmail.com>
	 <47824D25.5090005@hauke-m.de>
X-Google-Sender-Auth: 527d475ff32b9739
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 7, 2008 11:02 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> There is an other Problem.
>
> iwconfig shows me "Bit Rate=1 Mb/s" the hole time, but I'm able to
> download with an average of 440K/s as wget says.
>
> It's with PID rate control algorithm.

Thanks for reporting this, how'd it go with simple rate control
algorithm instead?

  Luis
