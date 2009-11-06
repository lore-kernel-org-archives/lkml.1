Return-Path: <linux-kernel-owner+w=401wt.eu-S1759500AbZKFQpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759500AbZKFQpn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 11:45:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759490AbZKFQpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 11:45:42 -0500
Received: from waste.org ([173.11.57.241]:38838 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759488AbZKFQpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 11:45:38 -0500
Subject: Re: Using netconsole and getting double prints
From: Matt Mackall <mpm@selenic.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <43e72e890911060832k1b831f32w93357c71b370e71c@mail.gmail.com>
References: <43e72e890911051654i19c18bf3nd397662ed79712c4@mail.gmail.com>
	 <1257484663.2873.622.camel@calx>
	 <43e72e890911060832k1b831f32w93357c71b370e71c@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Nov 2009 10:43:22 -0600
Message-ID: <1257525802.2873.753.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-06 at 08:32 -0800, Luis R. Rodriguez wrote:
> On Thu, Nov 5, 2009 at 9:17 PM, Matt Mackall <mpm@selenic.com> wrote:
> > On Thu, 2009-11-05 at 16:54 -0800, Luis R. Rodriguez wrote:
> >> I'm getting double prints when using netconsole. This used to happen
> >> to me and then I just enable debugging log level manually (dmesg -n 8)
> >> but now no matter what I try I always get double prints.
> >
> > This is the first report I've seen of that. Recommend investigating with
> > wireshark.
> 
> Matt, did you really mean wireshark? I'm a wireless guy so wireshark
> to me is this:
> 
> http://www.wireshark.org/

> The prints have nothing to do with protocols though. I can get a
> double print on a simple hello world driver.

Are you saying you get these double prints on the *local* machine? Are
the messages logged dmesg doubled too?

-- 
http://selenic.com : development and support for Mercurial and Linux


