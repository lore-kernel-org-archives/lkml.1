Return-Path: <linux-kernel-owner+w=401wt.eu-S1756183AbZKJMQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183AbZKJMQB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 07:16:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754942AbZKJMQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 07:16:00 -0500
Received: from ns.firmix.at ([62.141.48.66]:1130 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015AbZKJMP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 07:15:59 -0500
Subject: Re: FatELF patches...
From: Bernd Petrovitsch <bernd@firmix.at>
To: weigelt@metux.de
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20091110101000.GC575@nibiru.local>
References: <1257230619.5063.42.camel@eric-desktop.grokthis.net>
	 <1257247265.23142.21.camel@tara.firmix.at>
	 <20091110101000.GC575@nibiru.local>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Tue, 10 Nov 2009 13:15:48 +0100
Message-Id: <1257855348.795.1.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.67 on ns.firmix.at
X-Firmix-Spam-Score: -2.285 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.285 required=5
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
X-Firmix-Received-Date: Tue, 10 Nov 2009 13:16:04 CET
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-10 at 11:10 +0100, Enrico Weigelt wrote:
> * Bernd Petrovitsch <bernd@firmix.at> wrote:
> 
> > The only remotely useful benefit in the long run I can imagine is: The
> > permanent cross-compiling will make AC_TRY_RUN() go away. Or at least
> > the alternatives are applicable without reading the generated
> > configure.sh (and config.log) to guess how to tell the script some
> > details.
> 
> hmm, that could be the real killer argument - evolutionarily 
> sort out the guys who're too dumb to write proper buildscripts ;-)
Obviously your irony detector triggered;-)

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


