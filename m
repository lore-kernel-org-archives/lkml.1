Return-Path: <linux-kernel-owner+w=401wt.eu-S1756620AbYAYNVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbYAYNVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 08:21:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753958AbYAYNVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 08:21:35 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:38546 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbYAYNVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 08:21:34 -0500
Date: Fri, 25 Jan 2008 14:21:33 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Frank Seidel <fseidel@suse.de>
cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 012/196] nozomi driver
In-Reply-To: <200801251344.30427.fseidel@suse.de>
Message-ID: <Pine.LNX.4.64.0801251420320.15243@fbirervta.pbzchgretzou.qr>
References: <20080125071127.GA4860@kroah.com> <1201245134-4876-12-git-send-email-gregkh@suse.de>
 <Pine.LNX.4.64.0801250910230.12676@fbirervta.pbzchgretzou.qr>
 <200801251344.30427.fseidel@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 25 2008 13:44, Frank Seidel wrote:
>> >+/*
>> >+ * CHANGELOG
>> 
>> Changelogs go into git, not files, at least that is what was mentioned
>> time and again.
>
>i removed them
>
If you want to keep them, add it to the patch description; that way they will
be retained in "git log" without expanding the size of the .c file. :)
