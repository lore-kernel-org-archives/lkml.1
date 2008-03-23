Return-Path: <linux-kernel-owner+w=401wt.eu-S1759073AbYCWXBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759073AbYCWXBF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 19:01:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756324AbYCWXAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 19:00:40 -0400
Received: from ns01.unsolicited.net ([69.10.132.115]:39120 "EHLO
	ns01.unsolicited.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756185AbYCWXAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 19:00:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=simple; s=one; d=unsolicited.net;
	h=Message-ID:Date:From:User-Agent:MIME-Version:To:Subject:References:In-Reply-To:X-Enigmail-Version:Content-Type:Content-Transfer-Encoding;
	b=BHsoNnlyQ8iEvlv3PMBiB85CyHGekvtUWpN/LOXFg6+GONiSuegFcYJtquiVZs3CL8nYAhmnpLlk7nFBKw5kCz/2PadywOGAS5pHICYql5KktiUbdips4gwBNEL6sYHNgh3ZdkFh90GrYxcvX46TsqxPAhhtepfVuM7v0pszEHQ=;
Message-ID: <47E6E0E0.80002@unsolicited.net>
Date: Sun, 23 Mar 2008 22:59:44 +0000
From: David <david@unsolicited.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Kai <epimetreus@fastmail.fm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Serious performance regression in Wine applications and Linux
   2.6.24.*
References: <1206240595.9045.1243810639@webmail.messagingengine.com>   <47E63476.4020304@unsolicited.net> <1206309824.16550.1243881033@webmail.messagingengine.com>
In-Reply-To: <1206309824.16550.1243881033@webmail.messagingengine.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> This is strange, as my (two) Windows apps ran (and run) just fine under 
> 2.6.24 (and now under 2.6.25-rc6). Could you specify the applications 
> you're having problems with?
>
>   
Kai wrote:
> Originally, it was just about everything -- Wine itself, and most any
> app I tried to run with it.
>
> In my most recent tests, however, it only seems to affect Age of Wonders
> II and Age of Wonders Shadow Magic, which use very similar engines.
>
> On Sun, 23 Mar 2008 10:44:06 +0000, "David" <david@unsolicited.net>
> said:
>   

OK.. I don't run Windows games, so won't have come across these issues. 
Hopefully someone with scheduler knowledge might be able to reproduce.

David


