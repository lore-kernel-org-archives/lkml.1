Return-Path: <linux-kernel-owner+w=401wt.eu-S1757790AbZABNrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757790AbZABNrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 08:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754562AbZABNrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 08:47:05 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:43275 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbZABNrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 08:47:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=ocTrtlMiCjplN3xAv1IKw3zVUajsoyk7zVjHZ2nQrZSkpZg1wzakIk2Ng5Z3Yz3FLO
         TZsXNbRvPsITSlMjcw2Md1W5JaY3UxzUv9lCRg50WMLCC81VHnDhiNesAYzme2VRmerL
         Mfg1aUgR7hzyy39a7l1gIttsyCScVa6eWGrCw=
Message-ID: <495E1AA2.4010207@gmail.com>
Date: Fri, 02 Jan 2009 18:46:10 +0500
From: "Alexander E. Patrakov" <patrakov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; ru-RU; rv:1.8.1.19) Gecko/20081226 SeaMonkey/1.1.14
MIME-Version: 1.0
To: "Alexander E. Patrakov" <patrakov@gmail.com>, gregkh@suse.de,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       elliot.li.tech@gmail.com
Subject: Re: Enable CONFIG_USB_SUSPEND by default or some mobile HD can't
 be   unplugged safely
References: <20090101160343.GA4278@thyme.bj.intel.com> <495CFE38.6070603@gmail.com> <20090102133744.GB4833@thyme.bj.intel.com>
In-Reply-To: <20090102133744.GB4833@thyme.bj.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yan Li wrote:
> To be honest I tested neither Windows, I just picked up other Linux
> user's complaints (pretty much online) who are using both Windows and
> Linux and thus can compare.
> 
> Curiously, is this change in behavior btw XP and Vista another blunder
> MSFT made?

I don't know whether it is intentional. I don't have Vista installed on 
my computer (but had a beta of it on my old computer). However, Google 
search result for "vista usb flash light" suggests that other people see 
the change, too.

-- 
Alexander E. Patrakov
