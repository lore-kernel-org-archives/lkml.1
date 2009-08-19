Return-Path: <linux-kernel-owner+w=401wt.eu-S1751795AbZHSLnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbZHSLnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 07:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751656AbZHSLnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 07:43:20 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:45606 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbZHSLnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 07:43:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wxoyRzrrN2LhpOJSGAfiFeB1oGyCuNBQjC1XPVpqNmQWIkWs2D2Q8MMQ20J/7fZjVV
         IxMLNiJzo+sGpACnw1b0VyMyQLDWyaGADo3mzxIFVH0+bwuJPjgAcPQHaEhslu3fsRwK
         1/5oEDGaPSmUzn11sTgGmexH2Ply+BUjjiCAE=
MIME-Version: 1.0
In-Reply-To: <1250672475.25419.7.camel@johannes.local>
References: <4A89E768.7010207@dell.com>
	 <1250558643.30166.109.camel@localhost.localdomain>
	 <9b2b86520908180044l72cb8642j6256e246662f7971@mail.gmail.com>
	 <9b2b86520908180752k66feda09rf9034a96ac6ef470@mail.gmail.com>
	 <4A8AE459.8060102@dell.com>
	 <9b2b86520908181408v5f7875b6sea31d8d95cc08c0b@mail.gmail.com>
	 <1250631063.16393.14.camel@johannes.local> <4A8B246D.7050004@dell.com>
	 <1250672475.25419.7.camel@johannes.local>
Date: Wed, 19 Aug 2009 13:43:18 +0200
Message-ID: <4798d7930908190443g1c4ade81v327474ff8ec26567@mail.gmail.com>
Subject: Re: [PATCH 2/3] Add rfkill support to compal-laptop
From: Cezary Jackiewicz <cezary.jackiewicz@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Mario Limonciello <mario_limonciello@dell.com>,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Marcel Holtmann <marcel@holtmann.org>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Also, I'm not entirely clear about the semantics -- you've called the
> bit KILLSWITCH_MASK, but does it really control all technologies as a
> hard block, i.e. it toggles both the bluetooth and wireless hard block?

In compal's laptop - yes. Switch disables all radios, bluetooth and wifi.

--
Cezary
