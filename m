Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204Ab0BLQan (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 11:30:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47592 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756528Ab0BLQam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 11:30:42 -0500
X-Authority-Analysis: v=1.0 c=1 a=uTOmaDeAZlAA:10 a=7U3hwN5JcxgA:10 a=aAamoVld-443F8sU1p0A:9 a=HgNhwNo1bhxPHLr5qM0A:7 a=KlUSV5-pwiJF8aMqgC7uYG2fn7sA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [kernel.org users] XZ Migration discussion
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Jean Delvare <khali@linux-fr.org>
Cc: "J.H." <warthog9@kernel.org>, "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       users@kernel.org, lasse.collin@tukaani.org,
       linux-kernel <linux-kernel@vger.kernel.org>, mirrors@kernel.org
In-Reply-To: <20100212171149.5c9f78d2@hyperion.delvare>
References: <4B744E13.8040004@kernel.org>
	 <20100212150137.648dca7c@hyperion.delvare>
	 <1265988318.24271.30.camel@gandalf.stny.rr.com>
	 <20100212171149.5c9f78d2@hyperion.delvare>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 12 Feb 2010 11:30:39 -0500
Message-ID: <1265992239.24271.38.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-12 at 17:11 +0100, Jean Delvare wrote:

> What would you consider a reasonable turnaround time? 3 month? 6 month?
> More?
> 
> We could make a decision now, you update ketchup immediately, and the
> actual change happens at the specified date in the future.
> 

Usually users don't update ketchup until it breaks ;)

But sure, 3 months probably would be fine. Then Matt Mackall will start
getting emails about it not working, and he will forward them to me.
Where I can then point them to the new repository.

-- Steve


