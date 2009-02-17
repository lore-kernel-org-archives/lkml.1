Return-Path: <linux-kernel-owner+w=401wt.eu-S1753780AbZBQAUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780AbZBQAUm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 19:20:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751034AbZBQAUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 19:20:33 -0500
Received: from h155.mvista.com ([63.81.120.155]:3991 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750888AbZBQAUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 19:20:33 -0500
Message-ID: <499A02CA.7050509@ru.mvista.com>
Date: Tue, 17 Feb 2009 03:20:26 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk, rjw@sisk.pl, akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] libata-sff: fix 32-bit PIO ATAPI regression
References: <200902152224.25144.sshtylyov@ru.mvista.com> <4999FD1A.3080407@pobox.com>
In-Reply-To: <4999FD1A.3080407@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Jeff Garzik wrote:

>> Commit 871af1210f13966ab911ed2166e4ab2ce775b99d (libata: Add 32bit 
>> PIO support)
>> has caused all kinds of errors on the ATAPI devices, so it has been 
>> empirically

  It started to look as we still don't really know what caused all these 
errors... :-/

MBR, Sergei


