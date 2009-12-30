Return-Path: <linux-kernel-owner+w=401wt.eu-S1752614AbZL3MRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbZL3MRJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 07:17:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbZL3MRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 07:17:09 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:46033 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbZL3MRI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 07:17:08 -0500
Subject: Re: [PATCH]drivers/usb/core/sysfs.c:201 unused variable 'value'
From: Felipe Balbi <me@felipebalbi.com>
Reply-To: me@felipebalbi.com
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: =?ISO-8859-1?Q?Ren=E9?= Bolldorf <xsecute@googlemail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4B3B3905.4050200@ru.mvista.com>
References: <4B3A9589.6060201@googlemail.com>
	 <1262131313.28789.134.camel@gandalf>  <4B3B3905.4050200@ru.mvista.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Dec 2009 14:16:58 +0200
Message-ID: <1262175418.28789.194.camel@gandalf>
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

On Wed, 2009-12-30 at 14:27 +0300, Sergei Shtylyov wrote:
> Hello.
> 
> Felipe Balbi wrote:
> 
> >> The variable 'value' is unused in 'set_reset_quirk()'.
> >>
> >> Greetings René Bolldorf
> >>     
> >
> > I already sent a patch for that [1]
> >
> > [1] http://marc.info/?l=linux-usb&m=126203765207545&w=2
> >   
> 
>    And you weren't the first one:
> 
> http://marc.info/?l=linux-usb&m=126165643307894

hah, beat me by a few days :-p


-- 
balbi

