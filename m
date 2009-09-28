Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481AbZI1WcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbZI1WcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 18:32:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbZI1WcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 18:32:12 -0400
Received: from ns.firmix.at ([62.141.48.66]:5015 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753210AbZI1WcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 18:32:12 -0400
X-Greylist: delayed 551 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Sep 2009 18:32:11 EDT
Subject: Re: 32-rc1: "CROSS_COMPILE changed" message breaks compilation
From: Bernd Petrovitsch <bernd@firmix.at>
To: Pavel Machek <pavel@ucw.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org
In-Reply-To: <20090928192536.GE28514@elf.ucw.cz>
References: <20090928175605.GB28514@elf.ucw.cz>
	 <20090928190841.GA12004@merkur.ravnborg.org>
	 <20090928192536.GE28514@elf.ucw.cz>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Tue, 29 Sep 2009 00:22:43 +0200
Message-Id: <1254176563.2926.2.camel@gimli.petrovitsch.priv.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.28 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.28 required=5
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
X-Firmix-Received-Date: Tue, 29 Sep 2009 00:23:03 CEST
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Mon, 2009-09-28 at 21:25 +0200, Pavel Machek wrote: 
[...]
> What is the recommended way to run ccache, then?
I don't know if it's the recommended way but
----  snip  ----
make CC="ccache gcc"
----  snip  ----
works for me.

Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services

