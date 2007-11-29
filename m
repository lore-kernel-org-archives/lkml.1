Return-Path: <linux-kernel-owner+w=401wt.eu-S1762797AbXK2NDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762797AbXK2NDU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 08:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756567AbXK2NDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 08:03:10 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:55324 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760395AbXK2NDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 08:03:09 -0500
Date: Thu, 29 Nov 2007 14:03:02 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: git guidance
Message-ID: <20071129140302.75cdc81b@dhcp-255-175.norway.atmel.com>
In-Reply-To: <474EB478.8070907@imap.cc>
References: <474C9B31.8000408@imap.cc>
	<Pine.LNX.4.64.0711280019200.4181@fbirervta.pbzchgretzou.qr>
	<20071129002245.33096661@siona>
	<474EB478.8070907@imap.cc>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.1.0-rc1 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007 13:45:44 +0100
Tilman Schmidt <tilman@imap.cc> wrote:

> Haavard Skinnemoen schrieb:
> > 
> > No, use "git rebase --interactive" ;-)  
> 
> What's that? I can't find it in "man git-rebase".

I think it was added very recently; most distributions probably don't
have a recent enough version. git 1.5.3.4 includes "git rebase
--interactive", and you can read about it here.

http://www.kernel.org/pub/software/scm/git/docs/git-rebase.html

Haavard
