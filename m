Return-Path: <linux-kernel-owner+w=401wt.eu-S1763959AbZAHXNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763959AbZAHXNE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 18:13:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756660AbZAHXMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 18:12:53 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:38041 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbZAHXMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 18:12:52 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: duane@duaneellis.com
Subject: Re: kernel 2.4.37 usb acm hard lockup
Date: Fri, 9 Jan 2009 00:13:07 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <20090108141921.5c1bb9f86d671edec44bb378f25c04cc.a190016ce1.wbe@email.secureserver.net>
In-Reply-To: <20090108141921.5c1bb9f86d671edec44bb378f25c04cc.a190016ce1.wbe@email.secureserver.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901090013.08173.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Thursday 08 January 2009 22:19:21 schrieb duane@duaneellis.com:
> Hello, I have a linux-2.4.37 - kernel *HANG* hard lockup that I am
> trying to debug, ctl-alt-del does not fix the problem. The problem does
> not occur on current 2.6 kernels.

Hi,

linux-usb@vger.kernel.org is the list for usb stuff.

Can you get anything from alt-sysrq-t ?

	Regards
		Oliver
