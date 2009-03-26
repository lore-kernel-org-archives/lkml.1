Return-Path: <linux-kernel-owner+w=401wt.eu-S1759689AbZCZSFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759689AbZCZSFn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 14:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754851AbZCZSFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 14:05:33 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:22132 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224AbZCZSFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 14:05:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=tnMPD0OD3P8AIQXj31zi9A23SB3POjspd9EvbHJWniDO5vdDISxZ25H1/vF5eYvGvz
         7RJNcS2RX1RLa70rhFEYSJ2fBGAtKH/1ZMFwEJK4nm+5IJWbfx/zLavT/kfM32k5Fagt
         ywisi3Eg3+EZ/4wEynMychJqT5OMOqUTXmP5k=
MIME-Version: 1.0
In-Reply-To: <b2080d80903230812s2a33b635vf70f7736133570c7@mail.gmail.com>
References: <20090320030121.1fa8e6d3.akpm@linux-foundation.org>
	 <b2080d80903220626s5fffdbf3i907cb4b215670ce6@mail.gmail.com>
	 <b2080d80903200244u7fbcc150g6724a84c9b3b2054@mail.gmail.com>
	 <20090323020522.GF29466@mit.edu>
	 <b2080d80903230210w60d48530n9b98fdf71cf6fd18@mail.gmail.com>
	 <20090323121709.GD13368@mit.edu>
	 <b2080d80903230720m16af65c4t992b9cc34c44b914@mail.gmail.com>
	 <20090323150804.GG13368@mit.edu>
	 <b2080d80903230812s2a33b635vf70f7736133570c7@mail.gmail.com>
Date: Thu, 26 Mar 2009 19:05:29 +0100
X-Google-Sender-Auth: b061d1c5a5ba747a
Message-ID: <b2080d80903261105j20c103ci158ecd6fe9a65c59@mail.gmail.com>
Subject: Re: Severe data corruption with ext4
From: =?ISO-8859-1?Q?Richard_H=F6chenberger?= <richard@r-selected.de>
To: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ted,

I am considering moving my data to ext3, since in a week (or two) I
will have to use the computer on which the bug occured as a (hopefully
stable) production system. Should I keep an Image of the /usr
partition, in case you have any further questions or something?

Thanks for your help so far,

    Richard
