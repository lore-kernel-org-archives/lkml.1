Return-Path: <linux-kernel-owner+w=401wt.eu-S1758277AbXKZBQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277AbXKZBQw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 20:16:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756347AbXKZBQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 20:16:43 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:42547 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281AbXKZBQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 20:16:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Xy78R+R1cq3VeFogpRAfLpfEehqA6XOeeEprvDh0TTYBDuHUUTTFThY8zmhRlt5FHPZrSFXRvV6GeGXNwAYNMiHsLYkMmjcT6jkVIJaKOVKlgdY13rAYrXjbOgUKCEfaNm+9A3CpXpdPVLumabEW2JC4JDuf1GuttG0Qm4IQTl4=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Jeroen <j.geusebroek@gmail.com>
Subject: Re: forcedeth ethernet driver & Low power state
Date: Sun, 25 Nov 2007 17:16:35 -0800
User-Agent: KMail/1.9.1
Cc: "Robert Hancock" <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
References: <fa.XqgRE47bF/VjxtMudX1m05vea0g@ifi.uio.no> <4749C0B5.3010309@shaw.ca> <c22ebab10711251059k23178e20if60936dec105cab6@mail.gmail.com>
In-Reply-To: <c22ebab10711251059k23178e20if60936dec105cab6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711251716.36013.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 25 November 2007 10:59, Jeroen wrote:
> On Nov 25, 2007 7:36 PM, Robert Hancock <hancockr@shaw.ca> wrote:
> > Are you sure forcedeth even supports that feature? I haven't seen any
> > code for it, and certainly it should never be enabled by default..
>
> The windows driver does. I have to disable it because otherwise I have
> lot's of connection speed troubles. This is also what i see when I use a
> linux distro on the server unfortunately I can't disable it.

You need to prepare more extensive bug report, for starters.
What are "connection speed troubles"? Which kernel version?
Do you see any "interesting" messages in kernel log?
lspci output? ethtool output? etc...
--
vda
