Return-Path: <linux-kernel-owner+w=401wt.eu-S1758230AbXKTXHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230AbXKTXHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 18:07:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbXKTXGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 18:06:53 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:58923 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbXKTXGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 18:06:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=TRzqhSkZBv3jAOsxCl4+UWptpdbGk/ulErIEUWsvTMb7riVTsqAzsURPgsc39rRqvMv6gIksm5/7lHRBmq0qB/QnU7EC4/5rFPLi+zqk2Hn4daGUhXJxYiRUwWHY/or+n0MLdRsx/bFiN0sEwKp9nEVfYXTepaL0e4j/H+m1zwI=
Message-ID: <3d8471ca0711201506t6b2b88a0h9484f8a40a1f2e40@mail.gmail.com>
Date: Wed, 21 Nov 2007 00:06:49 +0100
From: "Guillaume Chazarain" <guichaz@yahoo.fr>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: 2.6.24-rc3: find complains about /proc/net
Cc: "Roland McGrath" <roland@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Pavel Emelyanov" <xemul@openvz.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Pavel Machek" <pavel@ucw.cz>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>, "Ulrich Drepper" <drepper@redhat.com>
In-Reply-To: <20071120230106.GD24380@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071119191000.GA1560@elf.ucw.cz> <200711192304.25087.rjw@sisk.pl>
	 <4743026B.2020907@openvz.org>
	 <m11wakshyz.fsf@ebiederm.dsl.xmission.com>
	 <20071120215914.GE24156@elte.hu>
	 <m1ve7wr28z.fsf@ebiederm.dsl.xmission.com>
	 <20071120223559.GA6655@elte.hu>
	 <20071120225457.B6E2D26F8BE@magilla.localdomain>
	 <20071120230106.GD24380@elte.hu>
X-Google-Sender-Auth: d582a373bf1e00b1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/07, Ingo Molnar <mingo@elte.hu> wrote:
> i guess it was a v2.6.24 change, hence a regression that needs to be
> fixed?

It seems to be

http://git.kernel.org/?p=linux/kernel/git/tglx/history.git;a=commitdiff;h=01660410

So, linux 2.6.0-test6

-- 
Guillaume
