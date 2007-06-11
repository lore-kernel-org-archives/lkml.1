Return-Path: <linux-kernel-owner+w=401wt.eu-S1760181AbXFKJbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760181AbXFKJbw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 05:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbXFKJbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 05:31:45 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:37243 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbXFKJbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 05:31:44 -0400
Message-ID: <466D15BB.2080705@gmail.com>
Date: Mon, 11 Jun 2007 11:28:27 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Denis Vlasenko <vda.linux@googlemail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Greg KH <gregkh@suse.de>, Jesper Juhl <jesper.juhl@gmail.com>,
       Tsugikazu Shibata <tshibata@ab.jp.nec.com>,
       linux-kernel@vger.kernel.org, m-ikeda@ds.jp.nec.com
Subject: Re: kconfig .po files in kernel tree? [Was: Documentation/HOWTO	translated
 into Japanese]
References: <20070610.204845.115909592.tshibata@ab.jp.nec.com> <20070610175228.GA28947@uranus.ravnborg.org> <466C49DB.6040409@gmail.com> <200706110159.00482.vda.linux@googlemail.com> <20070611001434.GD3588@stusta.de>
In-Reply-To: <20070611001434.GD3588@stusta.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2007 02:14 AM, Adrian Bunk wrote:

> On Mon, Jun 11, 2007 at 01:59:00AM +0200, Denis Vlasenko wrote:

>> I agree. i18n efforts won't help one iota because people just have
>> to know English in order to participate in l-k development.
>> They should be able to read _and_ reply_ to lkml posts,
>> and read and understnd code _and_ comments_.
>> ...
> 
> Kconfig is different since the target audience and the majority of users 
> are not kernel developers.

Well, hardly. The percentages quoted vary wildly with the point someone is 
trying to make but "user users" are expected to just use whatever their 
distribution provided them with meaning the Kconfig target audience is 
developers and "power users". Enough of the latter around certainly but I 
have no indication whatsoever that a significant number of them is lost in 
the water without Kconfig translations either.

Internationalization is not very useful, has great potential to introduce 
even more chronically bit-rotting content and is finally counter-productive 
  in maintaining a non-forking single community, at least in so far as it is 
today. One should spit on internationalization.

Rene.
