Return-Path: <linux-kernel-owner+w=401wt.eu-S1756529AbYABStA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529AbYABStA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 13:49:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbYABSst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 13:48:49 -0500
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:33899 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753025AbYABSss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 13:48:48 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=qmdtHgJ6rxo/4Z2YxkvYE0yA4Dd2z0tgGb15N6jXc1xBYsDDFByyohZD8xDqJyxe2opSB1JN1RSg7tGRjWUBeg5X2gCBzrHxnaMWgH9FYNLqw3ordSeuvvCoWsYh3aPT9+0ID8lNP3FTn30++q30adiwjrPZGtZqDbgEB4WFjmQ=  ;
X-YMail-OSG: uARibGMVM1lypd03DgthQtoIS2GK.oB27B9z5ISdKiMSHeJp5c4Ah2yqKQ5JN_PuQI1K4gsjpA--
From: David Brownell <david-b@pacbell.net>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb regression] Re: [PATCH 2.6.24-rc3] Fix /proc/net breakage
Date: Wed, 2 Jan 2008 10:48:44 -0800
User-Agent: KMail/1.9.6
Cc: Greg KH <greg@kroah.com>, Andreas Mohr <andi@lisas.de>,
       Ingo Molnar <mingo@elte.hu>, Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>, Pavel Emelyanov <xemul@openvz.org>,
       "Denis V. Lunev" <den@openvz.org>, USB list <linux-usb@vger.kernel.org>
References: <Pine.LNX.4.44L0.0801021052470.4861-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0801021052470.4861-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200801021048.45809.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 January 2008, Alan Stern wrote:
> 	 BTW, I don't recall ever seeing Tony's patch announced on
> linux-usb or linux-usb-devel.  Did I simply miss it?

I think he didn't post it.  I got some questions from him at
one point, which I answered, but as I recall he decided for
some reason to stop that work.

