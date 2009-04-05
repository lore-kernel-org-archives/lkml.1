Return-Path: <linux-kernel-owner+w=401wt.eu-S1757235AbZDEGNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235AbZDEGNz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 02:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755628AbZDEGNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 02:13:47 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:57220 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbZDEGNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 02:13:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=bu2LC7HWMKSi23LqXjRW8yw1NkZBzNC6MKXTZyhIc9E+a6y7jduEyCMkp5XN5fDnKP
         Yl2oKu3P1JHKez9gxFybjg6ixuF1ZTqBUvfgiGigJz0nWzmMQT9eui/6YcszJ1gBwkKL
         qf6FCbKP5UuVI0nRMRTDOPOWWPO/u8tt2wIWQ=
MIME-Version: 1.0
In-Reply-To: <9b1675090904042125g708076e6v665f5ecc7fa020a4@mail.gmail.com>
References: <9b1675090904041103v477913a5of06fa5c10ebee05f@mail.gmail.com>
	 <9b1675090904041131u28635d8dnc3d13e88000394b4@mail.gmail.com>
	 <20090405011355.GE7553@mit.edu>
	 <9b1675090904042117k77463227y66a872d52d027e7e@mail.gmail.com>
	 <9b1675090904042125g708076e6v665f5ecc7fa020a4@mail.gmail.com>
Date: Sun, 5 Apr 2009 00:13:44 -0600
Message-ID: <9b1675090904042313rb8178b6v1da3aeddfa57a869@mail.gmail.com>
Subject: Re: IO latency - a special case
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: Theodore Tso <tytso@mit.edu>,
       "Trenton D. Adams" <trenton.d.adams@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted,

I have no idea what "sar" is, and a google search doesn't appear to
reveal anything useful.  Where can I get this "sar" tool?

I also do not have "iostat" on my system, and again, google does not
appear to reveal an official page for that, and gentoo doesn't appear
to have a package for it.

I have output without those tools, if you want that.  I hit a 1 minute
load average of 46 this time, and 46 uninterruptible processes.

Thanks.
