Return-Path: <linux-kernel-owner+w=401wt.eu-S1753017AbZGJK2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbZGJK2x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 06:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750835AbZGJK2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 06:28:45 -0400
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:61853 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750811AbZGJK2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 06:28:44 -0400
From: Frans Pop <elendil@planet.nl>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: usb mouse not responding after resume
Date: Fri, 10 Jul 2009 12:28:40 +0200
User-Agent: KMail/1.9.9
Cc: linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <E1MPCb9-0007w0-BK@pomaz-ex.szeredi.hu>
In-reply-To: <E1MPCb9-0007w0-BK@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907101228.42047.elendil@planet.nl>
X-OriginalArrivalTime: 10 Jul 2009 10:28:42.0665 (UTC) FILETIME=[3299A190:01CA0149]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> Sometimes after resume the usb mouse plugged into my T60 notebook
> isn't working.  Unplugging and replugging it fixes the problem.  A
> keyboard is also plugged in, which works normally every time.
> 
> This has been happening on and off from about 2.6.30-rc* but in
> 2.6.31-rc* seems to be getting more frequent.
> 
> Here's the suspend-resume-replug part of the dmesg.  Not sure if it is
> enough, I'd be happy to provide more info.

The most obvious first question is: is there any difference in the 
messages between resumes where the mouse works and where it does not.

Cheers,
FJP
