Return-Path: <linux-kernel-owner+w=401wt.eu-S932904AbXBKW5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932904AbXBKW5a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 17:57:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932906AbXBKW5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 17:57:30 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:45086 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932904AbXBKW52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 17:57:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BchkENQGz6qwzkhKb0dd5/DrRtrGbdJEkFMp8WP1zg5UMZLY8v5QSyTxLhTLwD/oHWY7p4T98aHLKKV/cehEEdbNYblYnpiLkh5KuqgGX/u99n/M2Qbc3vNPTb1Sow6FgjOMAVT7O+SLGBDhkm5NqfJWTzBmNLH/VAhRXQddmdA=
Message-ID: <1a297b360702111457k3a38eefei485f814f980e58c6@mail.gmail.com>
Date: Mon, 12 Feb 2007 02:57:26 +0400
From: "Manu Abraham" <abraham.manu@gmail.com>
To: nigel@nigel.suspend2.net
Subject: Re: NAK new drivers without proper power management?
Cc: "Willy Tarreau" <w@1wt.eu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Pavel Machek" <pavel@ucw.cz>, "Arjan van de Ven" <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, tilman@imap.cc
In-Reply-To: <1171234027.4493.88.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1171058269.1484.64.camel@nigel.suspend2.net>
	 <1171059433.8675.195.camel@laptopd505.fenrus.org>
	 <20070210193851.GA3956@ucw.cz> <200702102320.39531.rjw@sisk.pl>
	 <1171147026.19894.16.camel@nigel.suspend2.net>
	 <20070211064636.GA12171@1wt.eu>
	 <1171234027.4493.88.camel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/12/07, Nigel Cunningham <nigel@nigel.suspend2.net> wrote:

> Neither am I. I'm just asking that new drivers have power management as
> standard.


What if the hardware doesn't support power management ?

regards,
manu
