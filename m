Return-Path: <linux-kernel-owner+w=401wt.eu-S1760277AbXK1BKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760277AbXK1BKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 20:10:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757500AbXK1BKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 20:10:31 -0500
Received: from hu-out-0506.google.com ([72.14.214.239]:17768 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094AbXK1BK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 20:10:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=V+HmW6fLNFP3ITNFdHLYvMg6MLt5oWfahe8GgYKjJrFt4PD3H3fVloXIL1BBuxmBiiPUPZ0Cl7wxPPfbfhM/Ch/roNWGTlee69zELYilAhQPhWN1J/wHPlZi4R56umveFPk8Z9A0I9NkEuR3JGXMKJz6R3nKrCdONVd8U+Ki3wE=
Message-ID: <474CBFB6.4020105@gmail.com>
Date: Wed, 28 Nov 2007 10:09:10 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Kjartan Maraas <kmaraas@broadpark.no>
CC: Tomas Carnecky <tom@dbservice.com>, Pavel Machek <pavel@ucw.cz>,
       linux-ide@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: laptop reboots right after hibernation
References: <473730F6.2010900@dbservice.com> <20071118105214.GB7299@ucw.cz> <4740692E.7010801@dbservice.com> <47409DA3.7070909@dbservice.com> <1195551141.2792.3.camel@localhost.localdomain>
In-Reply-To: <1195551141.2792.3.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kjartan Maraas wrote:
> I get this exact error message on a normal first time boot here. I'm
> using the latest fedora development kernel which is 2.6.24-rc2-git6
> based. And I have the latest BIOS from HP IIRC.
> 
> This is an HP nc6400 intel based laptop:

Care to post boot dmesg?  Or does harddisk detection fail because of this?

-- 
tejun
