Return-Path: <linux-kernel-owner+w=401wt.eu-S1757864AbXGPIu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864AbXGPIu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 04:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754634AbXGPIut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 04:50:49 -0400
Received: from no-way.org ([212.55.212.131]:33389 "EHLO no-way.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753750AbXGPIus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 04:50:48 -0400
Date: Mon, 16 Jul 2007 10:50:46 +0200
From: Flavio Curti <lists.fcu@no-way.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Flavio Curti <lists.fcu@no-way.org>, linux-kernel@vger.kernel.org
Subject: Re: panics with 16port Promise Supertrack EX Controller
Message-ID: <20070716085046.GE21260@no-way.org>
References: <20070708225246.GD16285@no-way.org> <6bffcb0e0707081620pf4afd46re9e74e18518b352a@mail.gmail.com> <46919688.1050005@yahoo.com.au> <20070715225155.GD21260@no-way.org> <20070715173515.49883f4a.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070715173515.49883f4a.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

On Sun, Jul 15, 2007 at 05:35:15PM -0700, Randy Dunlap wrote:
> On Mon, 16 Jul 2007 00:51:55 +0200 Flavio Curti wrote:
> > Ok, I now switched to cfg, and the machine panicd again. Panic attached.
> > Any help is appreciated.
> Make sure that you switched to "cfq" and not "cfg".

Oh, it is. Typo when writing the email, sorry...

kernel          /boot/vmlinuz-2.6.22.1-dorade root=/dev/sda1 ro
netconsole=4444@62.12.130.18/eth0,514@213.189.128.9/ elevator=cfq

Kind Regards

Flavio Curti

--
http://no-way.org/~fcu/
