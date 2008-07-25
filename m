Return-Path: <linux-kernel-owner+w=401wt.eu-S1756940AbYGYKmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940AbYGYKmt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 06:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258AbYGYKmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 06:42:40 -0400
Received: from ns.firmix.at ([62.141.48.66]:2707 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753765AbYGYKmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 06:42:39 -0400
Subject: Re: how much stuff is no longer "EXPERIMENTAL"?
From: Bernd Petrovitsch <bernd@firmix.at>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Grant Coady <gcoady.lk@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4889615D.9020706@nortel.com>
References: <alpine.LFD.1.10.0807241114000.4119@localhost.localdomain>
	 <h2ih845fmasm3coi3qapmqkknj0ghp6k7t@4ax.com>
	 <alpine.LFD.1.10.0807241606240.6474@localhost.localdomain>
	 <20080724211141.4fa557ca@lxorguk.ukuu.org.uk> <4889615D.9020706@nortel.com>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Fri, 25 Jul 2008 12:41:55 +0200
Message-Id: <1216982515.17267.108.camel@spike.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.342 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.342 required=5
X-Spam-Score: -2.342 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-25 at 01:15 -0400, Chris Friesen wrote:
> Alan Cox wrote:
> >> legitimately experimental content in the source tree.  surely *some*
> >> of that is suitably mature such that that dependency can be dropped.
> > 
> > What is the connection between age of code and experimental status ?
> 
> Is it reasonable for in-tree code to remain "experimental" indefinately?

Or until death. E.g. "devfs" went directly from "experimental" to
"obsolete".

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


