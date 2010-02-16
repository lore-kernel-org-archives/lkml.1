Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223Ab0BPQRq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 11:17:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47300 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757201Ab0BPQRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 11:17:44 -0500
X-Authority-Analysis: v=1.0 c=1 a=pi97quWTHqIA:10 a=7U3hwN5JcxgA:10 a=3ogXLCkblcU7IFHa5_AA:9 a=C8QRVOYyRN0voGwvLFJcD6XwAswA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: ketchup was Re: [kernel.org users] XZ Migration discussion
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Pavel Machek <pavel@ucw.cz>
Cc: Jean Delvare <khali@linux-fr.org>, lasse.collin@tukaani.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20100216153905.GA1541@ucw.cz>
References: <4B744E13.8040004@kernel.org>
	 <20100212150137.648dca7c@hyperion.delvare>
	 <1265988318.24271.30.camel@gandalf.stny.rr.com>
	 <20100216153905.GA1541@ucw.cz>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 16 Feb 2010 11:17:41 -0500
Message-ID: <1266337061.24271.138.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-16 at 16:39 +0100, Pavel Machek wrote:

> I'd really like to fix ketchup to behave sanely in late -rc stages:
> going from -rc6 to -rc8 is possible using two downloads through --rc7
> (like 100KB?)  instead of two big ones through full release (like
> 10MB).
> 
> But first step is --only-dl option -- when you want to cache the
> needed patches but not apply anything yet.
> 
> Please apply,
> 									Pavel

Can you send this to me as an official patch. With SoB and all.

Thanks,

-- Steve


