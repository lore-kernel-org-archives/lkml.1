Return-Path: <linux-kernel-owner+w=401wt.eu-S1758676AbYBRPTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758676AbYBRPTk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 10:19:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662AbYBRPTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 10:19:30 -0500
Received: from mho-02-bos.mailhop.org ([63.208.196.179]:52996 "EHLO
	mho-02-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643AbYBRPT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 10:19:29 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 216.15.117.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1980KOEBL95++sEQsmv69iV
Message-ID: <47B9A1E0.8020200@reed.com>
Date: Mon, 18 Feb 2008 10:18:56 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.9) Gecko/20071115 Fedora/2.0.0.9-1.fc8 Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [linux-kernel] [patch 2/2] x86: use explicit timing delay for
 pit accesses
References: <6gr00g$g7mc7l@smtp01.lnh.mail.rcn.net>
In-Reply-To: <6gr00g$g7mc7l@smtp01.lnh.mail.rcn.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops. the patch I just submitted for i8253.c didn't export the symbol 
needed by the pcspkr driver to build it as a module.  I will send the 
revised patch shortly.

