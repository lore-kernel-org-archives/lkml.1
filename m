Return-Path: <linux-kernel-owner+w=401wt.eu-S1751536AbZL3ACA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536AbZL3ACA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 19:02:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbZL3AB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 19:01:59 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:39909 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbZL3AB6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 19:01:58 -0500
Subject: Re: [PATCH]drivers/usb/core/sysfs.c:201 unused variable 'value'
From: Felipe Balbi <me@felipebalbi.com>
Reply-To: me@felipebalbi.com
To: =?ISO-8859-1?Q?Ren=E9?= Bolldorf <xsecute@googlemail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4B3A9589.6060201@googlemail.com>
References: <4B3A9589.6060201@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Dec 2009 02:01:53 +0200
Message-ID: <1262131313.28789.134.camel@gandalf>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8BIT
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-30 at 00:49 +0100, René Bolldorf wrote:
> The variable 'value' is unused in 'set_reset_quirk()'.
> 
> Greetings René Bolldorf

I already sent a patch for that [1]

[1] http://marc.info/?l=linux-usb&m=126203765207545&w=2

-- 
balbi

