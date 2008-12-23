Return-Path: <linux-kernel-owner+w=401wt.eu-S1752174AbYLWRjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbYLWRjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 12:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbYLWRjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 12:39:05 -0500
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:35147 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751079AbYLWRjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 12:39:04 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=tYffPkOXRtb2kaVJikFIUgR6UsAw3lzzwgpWKLtu3dw/5VXiRcO7Jlyc3GMiSrAigrK1/wqRsmdDAFQzpsvxTs9AMNAV1vFwKZWd6dhIdDSXLyuiSOdvJloqNZPRmu408RBMVqaHL/vW3jcsfs6WKtXh5Chqa3tz19hbxmZ0osc=  ;
X-YMail-OSG: 8KniF1EVM1mDKywH2qzs6jwz5.4PQamn8UMVfisx0rF09Vk2Vfc.3Ev4jZw1G2shFAVdPG7ktU8HJac0zoZ4fJGTRLtgyrbiaUyutriEcpef2CwBQqinbQh5b805pByCxC3ycJEav17gWJje6ohAemX.
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>, gregkh@suse.de,
       felipe.balbi@nokia.com
Subject: Re: [PATCH] musb: fix DaVinci build again
Date: Tue, 23 Dec 2008 09:38:59 -0800
User-Agent: KMail/1.9.10
Cc: linux-usb@vger.kernel.org, khilman@deeprootsystems.com,
       davinci-linux-open-source@linux.davincidsp.com,
       linux-kernel@vger.kernel.org
References: <200812072341.50012.sshtylyov@ru.mvista.com> <494E2450.9080601@ru.mvista.com> <4950CFAD.7020403@ru.mvista.com>
In-Reply-To: <4950CFAD.7020403@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200812230939.00508.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 December 2008, Sergei Shtylyov wrote:
>    For how much longer we'll have to wait for this issue to be resolved? 
> 2.6.28 is 2 days away (at most).

Yeah, I sent a DaVinci build fix patch in plenty of time to
be merged for *2.6.27* (!!!!) but still the key parts are
missing, and have not managed to make it into mainline.


